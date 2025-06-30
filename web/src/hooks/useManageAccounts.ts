
import { getAllBusses } from '@/service/bus';
import { getAllUsers } from '@/service/users';
import useManageStore from '@/stores/manage.store';
import { Unit } from '@/types';
import { useEffect, useState } from 'react';

interface fetchUser {
    _id: string
    first_name: string
    last_name: string
    user_type: string
    assigned_bus_id: string
}
interface fetchBus {
    _id: string
    bus_number: string
    plate_number: string
    today_driver: fetchUser
}

const useManageAccounts = () => {
    // TODO: fetched the cached data
    const [userPage, setUserPage] = useState<number>(1)
    const [unitPage, setUnitPage] = useState<number>(1)


    const { accounts, units, setAccounts, setUnits } = useManageStore.getState();

    const [loading, setLoading] = useState<boolean>(false);
    const [error, setError] = useState<string | null>(null);

    const assignDriverToUnit = (accountId: number, unitId?: number) => {
        setAccounts(
            accounts.map((acc) =>
                acc.id === accountId ? { ...acc, assignedUnitId: unitId } : acc
            )
        );
    };

    const fetchBusses = async (currentPage: number) => {
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
                assignedDriverId: bus.today_driver._id,
            }));
            setUnits(updatedBusses);
        }
        setLoading(false);
    };
    const fetchUsers = async (currentPage: number) => {
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
            }));
            setAccounts(updatedUsers);
        }
        setLoading(false);
    };
    useEffect(() => {
        fetchUsers(userPage)
    }, [userPage])

    useEffect(() => {
        fetchBusses(unitPage)
    }, [unitPage])

    return { accounts, units, userPage, unitPage, loading, error, setAccounts, setUnits, setUserPage, setUnitPage, assignDriverToUnit };
}

export default useManageAccounts