
import { assignUserToBus, getAllBusses, unassignDriverToBus } from '@/service/bus';
import { getAllUsers } from '@/service/users';
import useManageStore from '@/stores/manage.store';
import { fetchBus, fetchUser, Unit, Role, Account } from '@/types';
import { useCallback, useEffect, useState, useRef } from 'react';

const useManageAccounts = () => {
    const [userCursor, setUserCursor] = useState<string | null>(null)
    const [unitCursor, setUnitCursor] = useState<string | null>(null)
    const lastFetchedCursor = useRef<string | null>(null);
    const lastFetchedUnitCursor = useRef<string | null>(null);
    const hasLoadedUsers = useRef(false);
    const hasLoadedUnits = useRef(false);
    const [currentRole, setCurrentRole] = useState<string | null>(null);
    const roleData = useRef<Map<string, { accounts: Account[], cursor: string | null, hasMore: boolean }>>(new Map());

    const [total, setTotal] = useState<number>(1)
    const [commuterCount, setCommuterCount] = useState<number>(1)
    const [driverCount, setDriverCount] = useState<number>(1)
    const [adminCount, setAdminCount] = useState<number>(1)

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

    const fetchBusses = useCallback(async (cursor?: string | null) => {
        if (cursor && cursor === lastFetchedUnitCursor.current) {
            console.log('Skipping unit fetch - cursor is the same:', cursor);
            return;
        }

        setLoading(true);
        setError(null);

        const busses = await getAllBusses(cursor || undefined);
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
            console.log(busses["nextCursor"])
            setUnitCursor(busses["nextCursor"]);

            if (cursor) {
                setUnits((prev) => [...prev, ...updatedBusses]);
                lastFetchedUnitCursor.current = cursor;
            } else {
                setUnits(updatedBusses);
                lastFetchedUnitCursor.current = null;
                hasLoadedUnits.current = true;
            }
        }
        setLoading(false);
    }, [setUnits]);

    const fetchUsers = useCallback(async (cursor?: string | null, role?: string) => {
        const roleKey = role || 'all';

        if (cursor && cursor === lastFetchedCursor.current) {
            console.log('Skipping fetch - cursor is the same:', cursor);
            return;
        }

        setLoading(true);
        setError(null);

        const users = await getAllUsers(cursor || undefined, role);
        if (typeof users === 'string') {
            setAccounts([]);
            setError(users);
        } else {
            const updatedUsers = users["users"].map((user: fetchUser) => ({
                id: user._id,
                name: `${user.first_name} ${user.last_name}`,
                role: user.user_type as Role,
                assignedUnitId: user.assigned_bus_id,
                phone_number: user.phone_number,
                profile_picture_url: user.profile_picture_url,
                createdAt: user.createdAt
            }));
            console.log(users["nextCursor"])
            setUserCursor(users["nextCursor"]);

            if (cursor) {
                setAccounts((prev) => [...prev, ...updatedUsers]);
                lastFetchedCursor.current = cursor;

                const currentRoleData = roleData.current.get(roleKey);
                if (currentRoleData) {
                    currentRoleData.accounts = [...currentRoleData.accounts, ...updatedUsers];
                    currentRoleData.cursor = users["nextCursor"];
                    currentRoleData.hasMore = !!users["nextCursor"];
                }
            } else {
                setAccounts(updatedUsers);
                setTotal(users["total"])
                setCommuterCount(users["commuterCount"])
                setDriverCount(users["driverCount"])
                setAdminCount(users["adminCount"])
                lastFetchedCursor.current = null;
                hasLoadedUsers.current = true;

                roleData.current.set(roleKey, {
                    accounts: updatedUsers,
                    cursor: users["nextCursor"],
                    hasMore: !!users["nextCursor"]
                });
            }
        }
        setLoading(false);
    }, []);

    const fetchUsersWithRole = useCallback(async (role: string) => {
        const roleKey = role;

        if (roleData.current.has(roleKey)) {
            console.log('Role already loaded, switching to cached data');
            const cachedData = roleData.current.get(roleKey)!;
            setCurrentRole(role);
            setAccounts(cachedData.accounts);
            setUserCursor(cachedData.cursor);
            return;
        }

        console.log('Loading new role:', role);
        setCurrentRole(role);
        hasLoadedUsers.current = false;
        lastFetchedCursor.current = null;
        setUserCursor(null);
        setAccounts([]);
        await fetchUsers(null, role);
    }, [fetchUsers, setAccounts]);

    useEffect(() => {
        if (!hasLoadedUsers.current && accounts.length === 0) {
            fetchUsers(null, currentRole || undefined);
        }
    }, [fetchUsers, accounts.length, currentRole]);

    useEffect(() => {
        if (!hasLoadedUnits.current && units.length === 0) {
            fetchBusses(null);
        }
    }, [fetchBusses, units.length])

    const loadMoreUsers = useCallback(() => {
        console.log(userCursor, lastFetchedCursor.current)
        if (userCursor && !loading && userCursor !== lastFetchedCursor.current) {
            fetchUsers(userCursor, currentRole || undefined);
        }
    }, [userCursor, loading, fetchUsers, currentRole]);

    const loadMoreUnits = useCallback(() => {
        console.log(unitCursor, lastFetchedUnitCursor.current)
        if (unitCursor && !loading && unitCursor !== lastFetchedUnitCursor.current) {
            fetchBusses(unitCursor);
        }
    }, [unitCursor, loading, fetchBusses]);

    return {
        total,
        commuterCount,
        driverCount,
        adminCount,
        accounts,
        units,
        loading,
        error,
        setAccounts,
        setUnits,
        assignDriverToUnit,
        loadMoreUsers,
        loadMoreUnits,
        fetchUsersWithRole,
        lastFetchedCursor,
        userCursor,
        unitCursor
    };
}

export default useManageAccounts