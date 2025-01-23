import rateLimit from "express-rate-limit";

export const loginLimiter = rateLimit({
    windowMs: 5 * 60 * 1000,
    max: 20,
});
export const forgetPasswordLimiter = rateLimit({
    windowMs: 10 * 60 * 1000,
    max: 5,
});
export const sendCodeLimiter = rateLimit({
    windowMs: 1 * 60 * 1000,
    max: 2,
});
export const saveDormLimiter = rateLimit({
    windowMs: 1 * 60 * 1000,
    max: 20,
});