import { Request, Response } from 'express';

export const logoutUserController = async (req: Request, res: Response) => {
    try {
        res
            .status(200)
            .clearCookie(
                "refresh_token",
                {
                    httpOnly: true,
                    secure: true
                }
            )
            .json({ message: "User logged Out" })
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" })
    }
}