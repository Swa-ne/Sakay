import { FormEvent, useState } from "react";
import useManageAccounts from "./useManageAccounts";
import { BusModel, BusSchema } from "@/schema/account.unit.schema";
import { postBus } from "@/service/bus";



interface FormErrors {
    bus_number?: string;
    plate_number?: string;
}

const useDriverForm = () => {
    const { setUnits } = useManageAccounts();
    const [unitForm, setUnitForm] = useState<BusModel>({
        bus_number: "",
        plate_number: "",
    });
    const [errors, setErrors] = useState<FormErrors>({});

    const validateForm = (): boolean => {
        const result = BusSchema.safeParse(unitForm);

        if (!result.success) {
            const zodErrors = result.error.flatten().fieldErrors;

            const newErrors: FormErrors = {
                bus_number: zodErrors.bus_number?.[0],
                plate_number: zodErrors.plate_number?.[0],
            };

            setErrors(newErrors);
            return false;
        }

        setErrors({});
        return true;
    };
    const handleInputChange = (field: keyof BusModel, value: string) => {
        setUnitForm((prev) => ({ ...prev, [field]: value }));
        if (errors[field as keyof FormErrors]) {
            setErrors((prev) => ({ ...prev, [field]: undefined }));
        }
    };

    const handleSubmit = async (e: FormEvent, setOpen: (bool: boolean) => void) => {
        e.preventDefault();
        if (validateForm()) {
            const unit = await postBus(unitForm);
            if (typeof unit === "object") {
                setUnits((prevState) => [unit, ...prevState,])
                setOpen(false);
                setUnitForm({
                    bus_number: "",
                    plate_number: "",
                });
            } else {
                console.error("Internal Server Error")
            }
        }
    };
    return { unitForm, errors, setUnitForm, setErrors, validateForm, handleInputChange, handleSubmit }
}

export default useDriverForm