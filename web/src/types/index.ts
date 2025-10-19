
export type Role = 'DRIVER' | 'COMMUTER' | 'ADMIN';

export interface fetchUser {
    _id: string
    first_name: string
    last_name: string
    user_type: string
    email: string
    assigned_bus_id?: string
    phone_number?: string
    profile_picture_url: string
    createdAt?: string | null
}

export interface UsersResponse {
    users: fetchUser[];
    total: number;
    nextCursor: string | null;
    hasMore: boolean;
    commuterCount: number;
    driverCount: number;
    adminCount: number;
}
export interface fetchBus {
    _id: string
    bus_number: string
    plate_number: string
    today_driver?: fetchUser
    current_driver?: fetchUser[]
    speed?: number
    milage?: number
}
export interface Account {
    id: string;
    name: string;
    role: Role;
    assignedUnitId?: string | null;
    phone_number?: string;
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

export type TypesOfReport = "PERFORMANCE" | "INCIDENT" | "DRIVER";

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

export interface Announcement {
    _id: string,
    posted_by: fetchUser,
    edited_by?: fetchUser | null,
    headline: string,
    content: string,
    audience: "EVERYONE" | "DRIVER" | "COMMUTER",
    files: (string | File)[],
    existing_files?: string[],
    createdAt?: string,
    updatedAt?: string,
}
export interface AnnoucementLocal {
    headline: string;
    content: string;
    audience: 'EVERYONE' | 'DRIVER' | 'COMMUTER';
    existing_files?: string[];
}
export interface File {
    _id: string;
    file_name: string;
    file_type: string;
    file_size: number;
    file_category: "MEDIA" | "DOCUMENT";
    file_url: string;
    file_hash: string;
    createdAt?: Date;
    updatedAt?: Date;
}

export interface Message {
    _id?: string;
    message: string;
    sender_id: string;
    chat_id: string;
    isRead: boolean;
    createdAt: string;
    updatedAt: string;
}

export interface Inbox {
    _id: string;
    user_id: fetchUser;
    is_active: boolean;
    last_message: Message;
}

export interface BusInformation {
    _id?: string;
    bus_number?: string;
    plate_number?: string;
    location?: string;
    latitude: number;
    longitude: number;
    speed: number;
    milage?: number;
    travel_time?: number;
    is_used: boolean;
    timestamp?: string;
    assignedDriverId?: string | null;
}
export interface LatLngLiteral {
    lat: number;
    lng: number;
}