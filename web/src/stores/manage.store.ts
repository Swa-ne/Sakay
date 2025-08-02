import { create } from 'zustand';
import { Account, Unit } from '@/types';

interface ManageStore {
    accounts: Account[]
    units: Unit[]

    setAccounts: (update: Account[] | ((prev: Account[]) => Account[])) => void
    setUnits: (update: Unit[] | ((prev: Unit[]) => Unit[])) => void
    assignDriverToUnit: (driverId: string, unitId: string) => void
    removeDriverFromUnit: (driverId: string) => void
}

const useManageStore = create<ManageStore>((set) => ({
    accounts: [],
    units: [],

    setAccounts: (update) =>
        set((state) => ({
            accounts: typeof update === 'function' ? update(state.accounts) : update,
        })),
    setUnits: (update) =>
        set((state) => ({
            units: typeof update === 'function' ? update(state.units) : update,
        })),
    assignDriverToUnit: (driverId: string, unitId: string) => {
        set((state) => {
            const updatedAccounts = state.accounts.map(account =>
                account.id === driverId
                    ? { ...account, assignedUnitId: unitId }
                    : account
            );

            const updatedUnits = state.units.map(unit =>
                unit.id === unitId
                    ? { ...unit, assignedDriverId: driverId }
                    : unit
            );

            return {
                accounts: updatedAccounts,
                units: updatedUnits
            };
        });
    },
    removeDriverFromUnit: (driverId: string) => {
        set((state) => {
            const driver = state.accounts.find(account => account.id === driverId);
            const unitId = driver?.assignedUnitId;

            if (!unitId) {
                console.warn('Driver is not assigned to any unit');
                return state;
            }

            const updatedAccounts = state.accounts.map(account =>
                account.id === driverId
                    ? { ...account, assignedUnitId: null }
                    : account
            );

            const updatedUnits = state.units.map(unit =>
                unit.id === unitId
                    ? { ...unit, assignedDriverId: null }
                    : unit
            );

            return {
                accounts: updatedAccounts,
                units: updatedUnits
            };
        });
    },
}));

export default useManageStore;

export const ManageActions = {
    setAccounts: useManageStore.getState().setAccounts,
    setUnits: useManageStore.getState().setUnits,
    assignDriverToUnit: useManageStore.getState().assignDriverToUnit,
    removeDriverFromUnit: useManageStore.getState().removeDriverFromUnit,
}