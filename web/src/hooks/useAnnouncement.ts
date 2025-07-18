import { AnnouncementModel, AnnouncementSchema } from '@/schema/announcement.schema';
import { deleteAnnouncement, editAnnouncement, getAllAnnouncements, getAnnouncement, postAnnouncement } from '@/service/announcment';
import useAnnouncementStore from '@/stores/announcement.store';
import { AnnoucementLocal, Announcement } from '@/types';
import { useRouter } from 'next/navigation';
import { FormEvent, useCallback, useEffect, useState } from 'react';

interface FormErrors {
    headline?: string;
    content?: string;
    audience?: string;
}

const useAnnouncement = () => {
    const router = useRouter();

    const MAX_FILE_SIZE_MB = 50;
    const [announcementPage, setAnnouncementPage] = useState<number>(1)
    const [announcementForm, setAnnouncementForm] = useState<AnnouncementModel>({
        headline: "",
        content: "",
        audience: "EVERYONE",
    });
    const [files, setFiles] = useState<File[]>([]);

    const announcements = useAnnouncementStore((state) => state.announcements);
    const setAnnouncements = useAnnouncementStore((state) => state.setAnnouncements);
    const appendAnnouncements = useAnnouncementStore((state) => state.appendAnnouncements);

    const [announcement, setAnnouncement] = useState<Announcement | null>();

    const [loading, setLoading] = useState<boolean>(false);
    const [error, setError] = useState<string | null>(null);
    const [errors, setErrors] = useState<FormErrors>({});

    const fetchAnnouncement = useCallback(async (id: string) => {
        setLoading(true);
        setError(null);

        const cached = announcements.find((r) => r._id === id);

        if (cached) {
            setAnnouncement(cached);
            setLoading(false);
            return;
        }

        const fetched = await getAnnouncement(id);

        if (typeof fetched === 'string') {
            setAnnouncement(null);
            setError(fetched);
        } else {
            setAnnouncement(fetched);
        }

        setLoading(false);
    }, [announcements, setAnnouncement]);

    const fetchAnnouncements = useCallback(async (currentPage: number) => {
        setLoading(true);
        setError(null);

        const announcementsRes = await getAllAnnouncements(currentPage);
        if (typeof announcementsRes === 'string') {
            setAnnouncements([]);
            setError(announcementsRes);
        } else {
            if (currentPage > 1) {
                appendAnnouncements(announcementsRes);
            } else {
                setAnnouncements(announcementsRes);
            }
        }
        setLoading(false);
    }, [setAnnouncements, appendAnnouncements]);


    useEffect(() => {
        fetchAnnouncements(announcementPage)
    }, [announcementPage, fetchAnnouncements])

    const handleInputChange = (field: keyof AnnouncementModel, value: string) => {
        setAnnouncementForm((prev) => ({ ...prev, [field]: value }));
        if (errors[field as keyof FormErrors]) {
            setErrors((prev) => ({ ...prev, [field]: undefined }));
        }
    };

    const validateForm = (formData: AnnoucementLocal): boolean => {
        const result = AnnouncementSchema.safeParse(formData);

        if (!result.success) {
            const zodErrors = result.error.flatten().fieldErrors;

            const newErrors: FormErrors = {
                headline: zodErrors.headline?.[0],
                content: zodErrors.content?.[0],
                audience: zodErrors.audience?.[0],
            };

            setErrors(newErrors);
            return false;
        }

        setErrors({});
        return true;
    };

    const handleSubmit = async (e: FormEvent, setOpen: (bool: boolean) => void) => {
        e.preventDefault();
        if (validateForm(announcementForm)) {
            const formData = new FormData();
            formData.append('headline', announcementForm.headline ?? '');
            formData.append('content', announcementForm.content ?? '');
            formData.append('audience', announcementForm.audience ?? 'EVERYONE');
            if (files) {
                files.forEach((file) => formData.append('file', file));
            }

            const announcement = await postAnnouncement(formData);
            if (typeof announcement !== "string" && announcement.status === 200) {
                setAnnouncements((prevState) => [announcement.data, ...prevState,])
                setOpen(false);
                setAnnouncementForm({
                    headline: "",
                    content: "",
                    audience: "EVERYONE",
                });
            } else {
                console.log(announcement)
            }
            setFiles([])
        }
    };

    const handleDelete = async () => {
        if (announcement) {
            const res = await deleteAnnouncement(announcement._id)
            if (res) {

                setAnnouncements((prev) =>
                    prev.filter((a) => a._id !== announcement._id)
                );
                setAnnouncement(null);
                router.push('/announcements');
            }
        }
    };

    const handleEdit = async (
        updatedAnnouncement: Announcement,
        existing_files: string[] | undefined
    ) => {
        const formData = new FormData();
        formData.append('headline', updatedAnnouncement.headline ?? '');
        formData.append('content', updatedAnnouncement.content ?? '');
        formData.append('audience', updatedAnnouncement.audience ?? 'EVERYONE')
        if (files) {
            formData.append('announcement', JSON.stringify(updatedAnnouncement));
            files.forEach((file) => formData.append('file', file));
            formData.append('existing_files', JSON.stringify(existing_files));
        }
        const res = await editAnnouncement(updatedAnnouncement._id, formData)
        if (res) {
            setAnnouncements((prev) =>
                prev.map((a) => (a._id === updatedAnnouncement._id ? updatedAnnouncement : a))
            );
            setAnnouncement(updatedAnnouncement);
        }
        setFiles([])
    };
    const handleEditSubmit = async (e: React.FormEvent, onSave: () => void, setOpen: (open: boolean) => void, formData: AnnoucementLocal, announcement: Announcement) => {
        e.preventDefault();
        if (!validateForm(formData)) return;

        setLoading(true);

        try {
            const updatedAnnouncement: Announcement = {
                ...announcement,
                headline: formData.headline.trim(),
                content: formData.content.trim(),
                audience: formData.audience,
            };
            await handleEdit(updatedAnnouncement, formData.existing_files ?? []);

            onSave();
            setFiles([]);
            setOpen(false);
        } catch (error) {
            console.error('Error updating announcement:', error);
        } finally {
            setLoading(false);
        }
    };
    const handleFileSelect = async (files: FileList | null) => {
        if (!files) return;

        const validFiles: File[] = [];
        const invalidFiles: string[] = [];

        Array.from(files).forEach((file) => {
            if (file.size <= MAX_FILE_SIZE_MB * 1024 * 1024) {
                validFiles.push(file);
            } else {
                invalidFiles.push(file.name);
            }
        });

        if (invalidFiles.length > 0) {
            alert(`These files exceed 50MB and were not added:\n${invalidFiles.join('\n')}`);
        }

        if (validFiles.length > 0) {
            setFiles((prev) => [...prev, ...validFiles]);
        }
    };

    return { handleFileSelect, handleEditSubmit, handleDelete, handleEdit, announcement, fetchAnnouncement, announcementForm, setAnnouncementForm, handleInputChange, announcements, setAnnouncements, announcementPage, setAnnouncementPage, files, setFiles, loading, setLoading, error, errors, setErrors, setError, handleSubmit };
}

export default useAnnouncement