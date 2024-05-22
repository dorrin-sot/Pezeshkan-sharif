import { post_request } from "./base";

export function register_req(ssid, first_name, last_name, password, repeat_password, user_type, medical_id = null) {
    return post_request(
        '/auth/register',
        { ssid, first_name, last_name, password, repeat_password, user_type, medical_id }
    );
}