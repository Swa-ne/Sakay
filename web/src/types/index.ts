
export type Role = 'DRIVER' | 'COMMUTER' | 'ADMIN';

export interface Account {
    id: number;
    name: string;
    role: Role;
    assignedUnitId?: number | null;
}

export interface Unit {
    id: number;
    name: string;
    bus_number: string;
    plate_number: string;
    assignedDriverId?: number | null;
}