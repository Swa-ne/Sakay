
import { assignUserToBus, getAllBusses, unassignDriverToBus } from '@/service/bus';
import { getAllUsers } from '@/service/users';
import useManageStore from '@/stores/manage.store';
import { fetchBus, fetchUser, Unit } from '@/types';
import { useCallback, useEffect, useState } from 'react';



const useManageAccounts = () => {
    const [userPage, setUserPage] = useState<number>(1)
    const [unitPage, setUnitPage] = useState<number>(1)


    const accounts = useManageStore((state) => state.accounts);
    const units = useManageStore((state) => state.units);
    const setAccounts = useManageStore((state) => state.setAccounts);
    const setUnits = useManageStore((state) => state.setUnits);

    const [loading, setLoading] = useState<boolean>(false);
    const [error, setError] = useState<string | null>(null);

    const assignDriverToUnit = async (accountId: string, unitId?: string) => {
        let success = false;
        if (unitId) {
            const res = await assignUserToBus(unitId, accountId)
            if (res === "Success") {
                success = true
            }
        } else {
            const res = await unassignDriverToBus(accountId)
            if (res === "Success") {
                success = true
            }
        }
        if (success) {
            setAccounts((prev) =>
                prev.map((acc) =>
                    acc.id === accountId ? { ...acc, assignedUnitId: unitId } : acc
                )
            );
        }
    };

    const fetchBusses = useCallback(async (currentPage: number) => {
        setLoading(true);
        setError(null);

        const busses = await getAllBusses(currentPage);
        if (typeof busses === 'string') {
            setUnits([]);
            setError(busses);
        } else {
            const updatedBusses: Unit[] = busses.map((bus: fetchBus) => ({
                id: bus._id,
                name: `${bus.bus_number} - ${bus.plate_number}`,
                bus_number: bus.bus_number,
                plate_number: bus.plate_number,
                assignedDriverId: bus.today_driver ? bus.today_driver._id : null,
            }));
            setUnits(updatedBusses);
        }
        setLoading(false);
    }, [setUnits]);

    const fetchUsers = useCallback(async (currentPage: number) => {
        setLoading(true);
        setError(null);

        const users = await getAllUsers(currentPage);
        if (typeof users === 'string') {
            setAccounts([]);
            setError(users);
        } else {
            const updatedUsers = users.map((user: fetchUser) => ({
                id: user._id,
                name: `${user.first_name} ${user.last_name}`,
                role: user.user_type,
                assignedUnitId: user.assigned_bus_id,
                phone_number: user.phone_number,
                profile_picture_url: user.profile_picture_url
            }));
            setAccounts(updatedUsers);
        }
        setLoading(false);
    }, [setAccounts]);

    useEffect(() => {
        fetchUsers(userPage)
    }, [userPage, fetchUsers])

    useEffect(() => {
        fetchBusses(unitPage)
    }, [unitPage, fetchBusses])

    return { accounts, units, userPage, unitPage, loading, error, setAccounts, setUnits, setUserPage, setUnitPage, assignDriverToUnit };
}

export default useManageAccounts