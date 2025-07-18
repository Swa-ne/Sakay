/* eslint-disable @next/next/no-img-element */
'use client';
import { Download, FileIcon, FileText } from 'lucide-react';
import { useEffect, useState } from 'react';
import { Button } from './ui/button';
import { DialogContent, DialogHeader, DialogTitle } from './ui/dialog';
import { File } from '@/types';
import { getActualFileType, getFileExtension } from '@/utils/file.preview';
import { Badge } from './ui/badge';

interface FilePreviewProps {
    file: File | string;
    onClose: () => void;
}

const BACKEND_URL = process.env.NEXT_PUBLIC_API_URL;

const FilePreview = ({ file, onClose }: FilePreviewProps) => {
    const [content, setContent] = useState<string>('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string>('');

    const fileName = typeof file === 'string' ? file.split('/').pop() || 'Unknown' : file.file_name;
    const filePath = typeof file === 'string' ? file : file.file_url;
    const fileUrl = `${BACKEND_URL}/authentication/fetch-file?path=${encodeURIComponent(filePath)}`;
    const fileSize = typeof file === 'string' ? null : file.file_size;
    const fileCategory = typeof file === 'string' ? null : file.file_category;

    const actualFileType = getActualFileType(fileName);
    const fileExtension = getFileExtension(fileName);

    const isTextFile = (mimeType: string, extension: string) => {
        const textMimeTypes = ['text/plain', 'text/markdown', 'application/json', 'application/xml', 'text/html', 'text/css', 'application/javascript', 'application/typescript', 'text/csv'];

        const textExtensions = ['txt', 'md', 'json', 'js', 'ts', 'jsx', 'tsx', 'css', 'html', 'xml', 'csv', 'log', 'yml', 'yaml'];

        return textMimeTypes.includes(mimeType) || textExtensions.includes(extension);
    };

    const isImageFile = (mimeType: string, extension: string) => {
        const imageMimeTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml', 'image/bmp'];
        const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg', 'bmp', 'ico'];

        return imageMimeTypes.includes(mimeType) || imageExtensions.includes(extension);
    };

    const isVideoFile = (mimeType: string, extension: string) => {
        const videoMimeTypes = ['video/mp4', 'video/webm', 'video/ogg', 'video/quicktime'];
        const videoExtensions = ['mp4', 'webm', 'ogg', 'avi', 'mov', 'wmv', 'flv'];

        return videoMimeTypes.includes(mimeType) || videoExtensions.includes(extension);
    };

    const isAudioFile = (mimeType: string, extension: string) => {
        const audioMimeTypes = ['audio/mpeg', 'audio/wav', 'audio/ogg', 'audio/aac'];
        const audioExtensions = ['mp3', 'wav', 'ogg', 'aac', 'flac'];

        return audioMimeTypes.includes(mimeType) || audioExtensions.includes(extension);
    };

    const formatFileSize = (bytes: number) => {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return Number.parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    };
    useEffect(() => {
        const fetchFileContent = async () => {
            if (!fileUrl) return;

            setLoading(true);
            try {
                const response = await fetch(fileUrl);
                if (!response.ok) throw new Error('Failed to fetch file');
                const text = await response.text();
                setContent(text.slice(0, 10000));
            } catch {
                setError('Failed to load file content. The file might be too large or not accessible.');
            } finally {
                setLoading(false);
            }
        };
        if (isTextFile(actualFileType, fileExtension)) {
            fetchFileContent();
        }
    }, [fileUrl, actualFileType, fileExtension]);
    return (
        <DialogContent className='max-w-4xl max-h-[80vh] overflow-hidden'>
            <DialogHeader>
                <DialogTitle className='flex items-center gap-2'>
                    <FileText className='w-5 h-5' />
                    {fileName}
                    {fileCategory && (
                        <Badge variant='secondary' className='ml-2'>
                            {fileCategory}
                        </Badge>
                    )}
                    <Badge variant='outline' className='ml-2 text-xs'>
                        {fileExtension.toUpperCase()}
                    </Badge>
                </DialogTitle>
            </DialogHeader>
            <div className='flex-1 overflow-auto'>
                {isImageFile(actualFileType, fileExtension) && (
                    <div className='flex justify-center p-4'>
                        <img
                            src={fileUrl || '/placeholder.svg'}
                            alt={fileName}
                            className='max-w-full max-h-96 object-contain rounded-lg border'
                            onError={(e) => {
                                const target = e.target as HTMLImageElement;
                                target.src = '/placeholder.svg?height=200&width=200';
                            }}
                        />
                    </div>
                )}

                {isVideoFile(actualFileType, fileExtension) && (
                    <div className='flex justify-center p-4'>
                        <video src={fileUrl} controls className='max-w-full max-h-96 rounded-lg border'>
                            Your browser does not support the video tag.
                        </video>
                    </div>
                )}

                {isAudioFile(actualFileType, fileExtension) && (
                    <div className='flex justify-center p-4'>
                        <div className='w-full max-w-md'>
                            <audio src={fileUrl} controls className='w-full'>
                                Your browser does not support the audio tag.
                            </audio>
                        </div>
                    </div>
                )}

                {isTextFile(actualFileType, fileExtension) && (
                    <div className='p-4'>
                        {loading && (
                            <div className='flex items-center justify-center p-8'>
                                <div className='animate-spin rounded-full h-8 w-8 border-b-2 border-primary'></div>
                                <span className='ml-2'>Loading file content...</span>
                            </div>
                        )}
                        {error && <div className='text-red-500 p-4 bg-red-50 rounded-lg border border-red-200'>{error}</div>}
                        {content && (
                            <div className='space-y-2'>
                                <div className='flex items-center justify-between text-sm text-muted-foreground'>
                                    <span>File Content Preview</span>
                                    {content.length >= 10000 && <span className='text-orange-600'>Content truncated (showing first 10,000 characters)</span>}
                                </div>
                                <pre className='bg-muted p-4 rounded-lg text-sm overflow-auto whitespace-pre-wrap max-h-96 border font-mono'>{content}</pre>
                            </div>
                        )}
                    </div>
                )}

                {!isTextFile(actualFileType, fileExtension) && !isImageFile(actualFileType, fileExtension) && !isVideoFile(actualFileType, fileExtension) && !isAudioFile(actualFileType, fileExtension) && (
                    <div className='p-4 space-y-4'>
                        {(fileExtension === 'pptx' || fileExtension === 'docx' || fileExtension === 'xlsx') && fileUrl.startsWith('http') ? (
                            <iframe src={`https://view.officeapps.live.com/op/embed.aspx?src=${encodeURIComponent(fileUrl)}`} frameBorder='0' className='max-w-full max-h-96 border rounded-lg' />
                        ) : (
                            <div className='text-center text-muted-foreground'>
                                <FileIcon className='w-16 h-16 mx-auto mb-4' />
                                <p className='text-lg font-medium'>Preview not available</p>
                                <p className='text-sm'>File type: {fileExtension.toUpperCase()}</p>
                                <p className='text-sm'>Detected as: {actualFileType}</p>
                                <p className='text-sm mt-2'>Use the download button to view this file</p>
                            </div>
                        )}
                    </div>
                )}
            </div>
            <div className='flex justify-between items-center pt-4 border-t'>
                <div className='text-sm text-muted-foreground space-y-1'>
                    <div>Extension: {fileExtension.toUpperCase()}</div>
                    <div>Detected Type: {actualFileType}</div>
                    {fileSize && <div>Size: {formatFileSize(fileSize)}</div>}
                    {typeof file !== 'string' && <div>Category: {file.file_category}</div>}
                </div>
                <div className='flex gap-2'>
                    <Button variant='outline' size='sm' asChild>
                        <a href={fileUrl} download={fileName} target='_blank' rel='noopener noreferrer'>
                            <Download className='w-4 h-4 mr-1' />
                            Download
                        </a>
                    </Button>
                    <Button variant='outline' size='sm' onClick={onClose}>
                        Close
                    </Button>
                </div>
            </div>
        </DialogContent>
    );
};

export default FilePreview;
