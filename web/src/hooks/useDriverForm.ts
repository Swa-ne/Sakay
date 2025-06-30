import { UserModel, UserSchema } from "@/schema/account.unit.schema";
import { postDriver } from "@/service/users";
import { FormEvent, useState } from "react";
import useManageAccounts from "./useManageAccounts";



interface FormErrors {
    email?: string;
    password?: string;
    confirm_password?: string;
    first_name?: string;
    last_name?: string;
    phone_number?: string;
    birthday?: string;
}

const useDriverForm = () => {
    const { setAccounts } = useManageAccounts();
    const [userFrom, setUserForm] = useState<UserModel>({
        email_address: '',
        password_hash: '',
        confirmation_password: '',
        first_name: '',
        middle_name: '',
        last_name: '',
        phone_number: '',
        birthday: '',
    });
    const [errors, setErrors] = useState<FormErrors>({});

    const validateForm = (): boolean => {
        const result = UserSchema.safeParse(userFrom);

        if (!result.success) {
            const zodErrors = result.error.flatten().fieldErrors;

            const newErrors: FormErrors = {
                email: zodErrors.email_address?.[0],
                password: zodErrors.password_hash?.[0],
                confirm_password: zodErrors.confirmation_password?.[0],
                first_name: zodErrors.first_name?.[0],
                last_name: zodErrors.last_name?.[0],
                phone_number: zodErrors.phone_number?.[0],
                birthday: zodErrors.birthday?.[0],
            };

            setErrors(newErrors);
            return false;
        }

        setErrors({});
        return true;
    };

    const handleInputChange = (field: keyof UserModel, value: string) => {
        setUserForm((prev) => ({ ...prev, [field]: value }));
        if (errors[field as keyof FormErrors]) {
            setErrors((prev) => ({ ...prev, [field]: undefined }));
        }
    };

    const handleSubmit = async (e: FormEvent, setOpen: (bool: boolean) => void) => {
        e.preventDefault();
        if (validateForm()) {
            const user = await postDriver(userFrom);
            console.log(user)
            if (typeof user === "object") {
                setAccounts((prevState) => [user, ...prevState,])
                setOpen(false);
                setUserForm({
                    email_address: '',
                    password_hash: '',
                    confirmation_password: '',
                    first_name: '',
                    middle_name: '',
                    last_name: '',
                    phone_number: '',
                    birthday: '',
                });
            } else {
                console.log(user)
            }
        }
    };
    return { userFrom, errors, setUserForm, setErrors, validateForm, handleInputChange, handleSubmit }
}

export default useDriverForm