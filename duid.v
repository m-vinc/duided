module main

import rand
import encoding.hex
import regex

type Duid = []u8

enum DuidType as u8 {
        link_layer_time = 1
        vendor_assigned = 2
        link_layer_address = 3
        uuid = 4
}

const duid_types = [
        "link_layer_time"
        "vendor_assigned"
        "link_layer_address"
        "uuid"
]

fn DuidType.from_string(duid_string string) ?DuidType {
        match duid_string {
                "link_layer_time" { return .link_layer_time }
                "vendor_assigned" { return .vendor_assigned }
                "link_layer_address" { return .link_layer_address }
                "uuid" { return .uuid }
                else {
                        return none
                }
        }
}

 
fn (duid Duid) str() string {
        return hex.encode(duid)
}
 
fn (duid Duid) human_str() string {
        duid_str := duid.str()
        mut duid_human := []u8{}
        for i, c in duid_str {
                duid_human << c
                if i % 2 == 1 && i+1 < duid_str.len {
                        duid_human << ':'[0]
                }
        }
 
        return duid_human.bytestr()
}

fn is_valid_uuid(uuid string) bool {
	query := r"^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-4[a-fA-F0-9]{3}-[8|9|aA|bB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}$"
	mut re := regex.regex_opt(query) or { panic(err) }

	return re.matches_string(uuid)
}

fn DuidType.uuid(uuid_string string) !Duid {
	mut uuid := rand.uuid_v4()

	if uuid_string != "" {
		if !is_valid_uuid(uuid_string) {
			return error("invalid uuid")
		}
		uuid = uuid_string
	}

	mut uuid_hex := [u8(0x00), 0x04]
	uuid_hex << hex.decode(uuid.replace("-", ""))!

	return Duid(uuid_hex)
}

