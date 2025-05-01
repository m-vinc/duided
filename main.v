module main

import os
import cli
import encoding.hex
import crypto.sha256

// https://datatracker.ietf.org/doc/html/rfc8415#section-11
// https://datatracker.ietf.org/doc/html/rfc6355

fn show_nm_duid() cli.Command {
	mut cmd := cli.Command{
		name:    'show'
		description: 'Show the DUID Network Manager will use based on /etc/machine-id',
                execute: fn (cmd cli.Command) ! {
			human_readable := cmd.flags.get_bool('human_readable') or { false }
			machine_id := os.read_file("/etc/machine-id")!.trim_space()
			hex_machine_id := hex.decode(machine_id)!
			sum := sha256.sum(hex_machine_id)
			mut duid_bytes := [u8(0x00), 0x04]
			duid_bytes << sum[0..16]

			duid := Duid(duid_bytes)
			match human_readable {
				true {
					println(duid.human_str())
				}
				false {
					println(duid.str())
				}
			}
                }
        }

	cmd.add_flag(cli.Flag{
		flag: .bool
		name: 'human_readable'
		abbrev: 'h'
	})

	return cmd
}

fn generate_duid() cli.Command {
	mut cmd := cli.Command{
		name:    'gen'
		description: 'Generate a DUID using different method: ${duid_types}',
                execute: fn (cmd cli.Command) ! {
			human_readable := cmd.flags.get_bool('human_readable') or { false }
			duid_type := DuidType.from_string(cmd.flags.get_string('duid_type')!)

			if duid_type != none {
				mut duid := Duid([]u8{})
				match duid_type {
					.link_layer_time {
						println("unsupported")
						exit(1)
					}
					.vendor_assigned {
						println("unsupported")
						exit(1)
					}
					.link_layer_address {
						println("unsupported")
						exit(1)
					}
					.uuid {
						uuid := cmd.flags.get_string('uuid') or { "" }
						duid = DuidType.uuid(uuid)!
					}
				}

				if human_readable {
					println(duid.human_str())
					return
				}

				println(duid.str())
				return
			}


			println("unknown duid type. supported: ${duid_types.join(", ")}")



                }
        }

	cmd.add_flag(cli.Flag{
		flag: .bool
		name: 'human_readable'
		abbrev: 'h'
	})

	cmd.add_flag(cli.Flag{
		flag: .string
		name: 'duid_type'
		abbrev: 't'
		default_value: ["uuid"]
	})

	return cmd
}



fn main() {
	mut app := cli.Command{
        	name:        'duided'
        	description: 'duided'
        	execute:     fn (cmd cli.Command) ! {
			cmd.execute_help()
        	}
        	commands:    [
        		show_nm_duid()
			generate_duid()
		]
	}
	app.setup()
	app.parse(os.args)
}
