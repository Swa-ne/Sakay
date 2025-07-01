
export type Role = 'DRIVER' | 'COMMUTER' | 'ADMIN';

export interface fetchUser {
    _id: string
    first_name: string
    last_name: string
    user_type: string
    assigned_bus_id: string
    phone_number: string
    profile_picture_url: string
}
export interface fetchBus {
    _id: string
    bus_number: string
    plate_number: string
    today_driver?: fetchUser
}
export interface Account {
    id: string;
    name: string;
    role: Role;
    assignedUnitId?: string | null;
    phone_number: string;
    profile_picture_url: string;
}

export interface Unit {
    id: string;
    name: string;
    bus_number: string;
    plate_number: string;
    assignedDriverId?: string | null;
}

export interface Report {
    _id: string,
    bus: fetchBus,
    reporter: fetchUser,
    investigator?: string | null,
    driver?: fetchUser | null,
    type_of_report: TypesOfReport,
    description?: string | null,
    place_of_incident?: string | null,
    time_of_incident?: string | null,
    date_of_incident?: string | null,
    driving_rate?: number | null,
    service_rate?: number | null,
    reliability_rate?: number | null,
    is_open: boolean,
    createdAt?: string | null,
    updatedAt?: string | null,
}

export type TypesOfReport = "PERFORMANCE" | "INCIDENT" | "MAINTENANCE";

export interface ReportStatItem {
    count: number;
    change: number;
}

export interface FetchReportStats {
    open: ReportStatItem;
    closed: ReportStatItem;
    assigned: ReportStatItem;
    unassigned: ReportStatItem;
}