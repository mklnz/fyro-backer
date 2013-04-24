# Fyro::Back

FyroBacker is a simple DB backup utility written in Ruby.
PostgreSQL and MySQL are supported.

## Installation
    git clone https://github.com/mklnz/fyro-backer.git
    cd fyro-backer && gem build fyro-backer.gemspec && gem install fyro-backer

## Usage

    $ fyro-backer backup [config_file]

See spec/test_config.yml for sample config

## Scheduling

Add the following to your crontab
0 0 * * * /bin/bash -l -c 'fyrobacker backup /path/to/config.yml >> /path/to/backup.log'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
