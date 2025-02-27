import { Inbox } from "../models/chat/inbox.model";
import { Message } from "../models/chat/message.model";

export async function getAllInboxes(page: string) {
    try {
        const inbox = await Inbox.find({ is_active: true })
            .sort({ createdAt: -1 })
            .populate("user_id")
            .skip((parseInt(page) - 1) * 30)
            .limit(30);
        return { message: inbox, httpCode: 200 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export async function getLastMessageFromInbox(chat_id: string) {
    try {
        const last_message = await Message.findOne({ chat_id })
            .sort({ createdAt: -1 }).limit(1);
        return { message: last_message, httpCode: 200 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export async function createInbox(user_id: string) {
    try {
        const available_inbox = await inboxAvailable(user_id);
        if (available_inbox.httpCode === 200) {
            return { message: available_inbox.message, httpCode: 200 };
        } else if (available_inbox.httpCode === 404) {
            const inbox = await new Inbox({ user_id }).save();
            return { message: inbox._id, httpCode: 200 };
        }

        return { error: available_inbox.error, httpCode: available_inbox.httpCode };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export async function openInboxByUserID(user_id: string) {
    try {
        const inbox = await Inbox.findOne({ user_id });
        if (!inbox) {
            return 'Inbox not found';
        }
        return { message: inbox, httpCode: 200 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}

export async function getChatMessages(chat_id: string, page: string) {
    try {
        const result = await Message.find({ chat_id })
            .sort({ createdAt: -1 })
            .skip((parseInt(page) - 1) * 30)
            .limit(30);
        return { message: result, httpCode: 200 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export async function saveMessage(message: string, sender_id: string, chat_id: string) {
    try {
        const inbox = await Inbox.findById(chat_id);
        if (!inbox) {
            return { message: 'Inbox not found', httpCode: 404 };
        }
        await new Message({ message, sender_id, chat_id }).save();
        if (!inbox.is_active) {
            inbox.is_active = true;
        }
        await inbox.save();
        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export async function inboxAvailable(user_id: string) {
    try {
        const inbox = await Inbox.findOne({
            user_id
        });
        if (inbox) {
            return { message: inbox._id, httpCode: 200 };
        }
        return { error: "Inbox not found", httpCode: 404 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export async function openCreatedInboxContentByChatID(chat_id: string) {
    try {
        const inbox = await Inbox.findById(chat_id).populate("user_id");
        if (!inbox) {
            return { message: 'Chat ID not found', httpCode: 404 }
        }
        // return { message: { ...inbox, ...last_message }, httpCode: 200 }
        return { message: { ...inbox._doc }, httpCode: 200 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
