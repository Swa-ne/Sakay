import { create } from 'zustand';
import { Account, Unit } from '@/types';

interface ManageStore {
    accounts: Account[]
    units: Unit[]

    setAccounts: (update: Account[] | ((prev: Account[]) => Account[])) => void
    setUnits: (update: Unit[] | ((prev: Unit[]) => Unit[])) => void
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
}));

export default useManageStore;