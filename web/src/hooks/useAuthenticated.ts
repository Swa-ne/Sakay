import { useEffect, useState } from 'react'
import { authenticateToken } from '@/service/auth'
import { connectAdminSocketEvents, connectSocket } from '@/service/websocket/realtime'

interface AuthStatus {
    isAuthenticated: boolean | null
    userType: string | null
}

export const useAuthenticated = (): AuthStatus => {
    const [isAuthenticated, setIsAuthenticated] = useState<boolean | null>(null)
    const [userType, setUserType] = useState<string | null>(null)

    useEffect(() => {
        const checkAuth = async () => {
            const result = await authenticateToken()
            if (typeof result === 'object' && result.is_authenticated) {
                setIsAuthenticated(true)
                setUserType(result.user_type)
                if (result.user_type === "ADMIN") {
                    connectSocket()
                    connectAdminSocketEvents()
                }
            } else {
                setIsAuthenticated(false)
                setUserType(null)
            }
        }

        checkAuth()
    }, [])

    return { isAuthenticated, userType }
}
