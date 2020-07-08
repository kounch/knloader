#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- mode: Python; tab-width: 4; indent-tabs-mode: nil; -*-
# Do not change the previous lines. See PEP 8, PEP 263.
"""
knloader Cache Builder

    Copyright (c) 2020 @Kounch

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

import sys
import os
import argparse
import logging
import gettext

try:
    from pathlib import Path
except (ImportError, AttributeError):
    from pathlib2 import Path

__MY_NAME__ = 'cache_builder.py'
__MY_VERSION__ = '0.11'

__MAXNAME_L__ = 23
__MAXPATH_L__ = 65

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.INFO)
LOG_FORMAT = logging.Formatter(
    '%(asctime)s [%(levelname)-5.5s] - %(name)s: %(message)s')
LOG_STREAM = logging.StreamHandler(sys.stdout)
LOG_STREAM.setFormatter(LOG_FORMAT)
LOGGER.addHandler(LOG_STREAM)

path_locale = os.path.dirname(__file__)
path_locale = os.path.join(path_locale, 'locale')
gettext.bindtextdomain(__MY_NAME__, localedir=path_locale)
gettext.textdomain(__MY_NAME__)
_ = gettext.gettext


def main():
    """Main Routine"""

    arg_data = parse_args()

    str_msg = _('Start...')
    LOGGER.debug(str_msg)

    content = []
    with open(arg_data['input']) as f:
        str_msg = _('Processing: {0}')
        LOGGER.debug(str_msg.format(arg_data['input']))
        content = f.readlines()
        content = [x.strip() for x in content]

    if len(content):
        base_path = content[0]
        content = content[1:]
    arr_banks = []
    b_bank = b''
    i_bank = 0
    i_games = 0
    for line in content:
        arr_line = line.split(',')
        if arr_line and len(arr_line) > 3:
            i_games += 1
            LOGGER.debug('{0} . {1}'.format(len(arr_banks), arr_line))
            # Name
            b_line = truncate_to_bytes(arr_line[0], __MAXNAME_L__)
            # Mode
            b_line += int(arr_line[1]).to_bytes(1, byteorder='little')
            # Directory
            b_line += truncate_to_bytes(arr_line[2], __MAXPATH_L__)
            # File
            b_line += truncate_to_bytes(arr_line[3], __MAXPATH_L__)
            # Image
            if len(arr_line) > 4:
                b_line += truncate_to_bytes(arr_line[4], __MAXPATH_L__)
            else:
                b_line += (b'\0' * __MAXPATH_L__)

            i_bank += 219  # Address Counter

            if (i_bank < 16207):
                # Expand Bank
                b_bank += b_line
            else:
                # Bank is full
                arr_banks.append(b_bank)
                b_bank = b_line
                i_bank = 219
                if len(arr_banks) > 31:
                    str_msg = _(
                        'This cache will only work on 2MiB expanded hardware')
                    LOGGER.warning(str_msg)
                if len(arr_banks) > 99:
                    str_msg = _(
                        'Cache exceeds 2MiB! Please remove data from BDT file')
                    LOGGER.error(str_msg)
                    raise Exception(str_msg)
        else:
            str_msg = _('Bad Line: {0}')
            LOGGER.warning(str_msg.format(line))

    if i_bank > 0:
        if i_bank < 16207:
            b_bank += (b'\0' * (16206 - len(b_bank)))
        # Append last bank if needed
        arr_banks.append(b_bank)

    # Compute last page and position in page
    maxpag = int((i_games - 1) / 22)
    maxpos = 1 + int((i_games - 1) % 22)

    str_msg = _('Total: {0} - Base Path: "{1}"')
    LOGGER.debug(str_msg.format(i_games, base_path))
    str_msg = _('Maxpag: {0} - Maxpos: {1}')
    LOGGER.debug(str_msg.format(maxpag, maxpos))

    # Store Base Path, and last page and position
    arr_banks[0] += b'\0' * 46
    arr_banks[0] += maxpag.to_bytes(2, byteorder='little')
    arr_banks[0] += maxpos.to_bytes(1, byteorder='little')
    arr_banks[0] += truncate_to_bytes(base_path, 129)

    i_bank = 13
    for b_bank in arr_banks:
        b_bank += (b'\0' * (16384 - len(b_bank)))
        o_file = Path(arg_data['output'], 'cache{0}'.format(i_bank))
        with open(o_file, 'wb') as output:
            str_msg = _('Writing: "{0}"')
            LOGGER.debug(str_msg.format(o_file))
            output.write(b_bank)
            i_bank += 1

    str_banks = 'cache13'
    if i_bank > 14:
        str_banks += '...cache{0}'.format(i_bank - 1)
    str_msg = 'Cache data created at: {0}\n'
    str_msg += 'Copy {1} to your SD card into: /tmp/knloader'
    str_msg = _(str_msg)
    print(str_msg.format(arg_data['output'], str_banks))

    str_msg = _('Finished.')
    LOGGER.debug(str_msg)


# Functions
# ---------


def parse_args():
    """Command Line Parser"""
    str_hlp_input = _('Input path to BDT text file')
    str_hlp_output = _('Output directory path')

    parser = argparse.ArgumentParser(description='knloader Cache Builder')
    parser.add_argument('-v',
                        '--version',
                        action='version',
                        version='%(prog)s {}'.format(__MY_VERSION__))
    parser.add_argument('-i',
                        '--input',
                        required=True,
                        action='store',
                        dest='input_path',
                        help=str_hlp_input)
    parser.add_argument('-o',
                        '--output',
                        action='store',
                        dest='output_path',
                        help=str_hlp_output)

    arguments = parser.parse_args()

    values = {}

    i_path = None
    if arguments.input_path:
        i_path = Path(arguments.input_path)

    o_path = Path.cwd()
    if arguments.output_path:
        o_path = Path(arguments.output_path)

    if not i_path.exists():
        str_msg = _('Path not found: {0}')
        LOGGER.error(str_msg.format(i_path))
        str_msg = _('Input path does not exist!')
        raise IOError(str_msg)

    if not i_path.is_file():
        str_msg = _('Path is not a file: {0}')
        LOGGER.error(str_msg.format(i_path))
        str_msg = _('Input path is not a file!')
        raise IOError(str_msg)

    if not o_path.exists():
        str_msg = _('Path not found: {0}')
        LOGGER.error(str_msg.format(o_path))
        str_msg = _('Output path does not exist!')
        raise IOError(str_msg)

    if not o_path.is_dir():
        str_msg = _('Path is not a directory: {0}')
        LOGGER.error(str_msg.format(o_path))
        str_msg = _('Output path is not a dir!')
        raise IOError(str_msg)

    values['input'] = i_path
    values['output'] = o_path

    return values


def truncate_to_bytes(str_data, i_length):
    """ """

    if len(str_data) > i_length - 1:
        str_data = str_data[:i_length - 1]

    b_data = bytes(str_data, "ascii") + (b'\0' * (i_length - len(str_data)))
    return b_data


if __name__ == '__main__':
    main()
