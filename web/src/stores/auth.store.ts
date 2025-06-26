import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AuthState {
    access_token: string
    email: string
    first_name: string
    last_name: string
    profile: string
    user_id: string
    user_type: string
}

interface AuthStoreState extends AuthState {
    setAll: (data: Partial<AuthState>) => void
    reset: () => void
}

export const useAuthStore = create<AuthStoreState>()(
    persist(
        (set) => ({
            access_token: '',
            email: '',
            first_name: '',
            last_name: '',
            profile: '',
            user_id: '',
            user_type: '',

            setAll: (data) => set((state) => ({ ...state, ...data })),
            reset: () =>
                set(() => ({
                    access_token: '',
                    email: '',
                    first_name: '',
                    last_name: '',
                    profile: '',
                    user_id: '',
                    user_type: '',
                })),
        }),
        {
            name: 'user',
        }
    )
)
