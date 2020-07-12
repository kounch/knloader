#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- mode: Python; tab-width: 4; indent-tabs-mode: nil; -*-
# Do not change the previous lines. See PEP 8, PEP 263.
"""
knloader Cache Converter To BDT

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
from struct import unpack
import csv

try:
    from pathlib import Path
except (ImportError, AttributeError):
    from pathlib2 import Path

__MY_NAME__ = 'cache2bdt.py'
__MY_VERSION__ = '1.0'

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

    i_bank = 13
    bdt_data = []
    for child in sorted(arg_data['input'].glob('**/cache*')):
        child_path = Path(arg_data['input'], child)
        if child_path.name == 'cache{0}'.format(i_bank):
            if i_bank == 13:
                base_path = extract_base(child_path)
                bdt_data += [base_path]
            bdt_data += extract_bank(child_path)
            i_bank += 1

    if bdt_data:
        with open(arg_data['output'], 'w', newline="\n") as f:
            writer = csv.writer(f)
            writer.writerows(bdt_data)

            str_msg = 'BDT file created at: {0}\n'
            str_msg = _(str_msg)
            print(str_msg.format(arg_data['output']))

    str_msg = _('Finished.')
    LOGGER.debug(str_msg)


# Functions
# ---------


def parse_args():
    """Command Line Parser"""
    str_hlp_input = _('Directory path where cache files are')
    str_hlp_output = _('New BDT path')

    parser = argparse.ArgumentParser(
        description='knloader Cache Converter to BDT')
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

    o_path = Path(Path.cwd(), 'knloader.bdt')
    if arguments.output_path:
        o_path = Path(arguments.output_path)

    if not i_path.exists():
        str_msg = _('Path not found: {0}')
        LOGGER.error(str_msg.format(i_path))
        str_msg = _('Input path does not exist!')
        raise IOError(str_msg)

    if not i_path.is_dir():
        str_msg = _('Path is not a directory: {0}')
        LOGGER.error(str_msg.format(i_path))
        str_msg = _('Input path is not a dir!')
        raise IOError(str_msg)

    values['input'] = i_path
    values['output'] = o_path

    return values


def extract_base(p_bank):
    str_record = '{0}sb'.format(128)
    with open(p_bank, 'rb') as f:
        b_data = f.read()

    i_offset = 16255

    zxdata = unpack(str_record, b_data[i_offset:i_offset + 129])
    arrdata = list(zxdata)
    arrdata[0] = arrdata[0] = arrdata[0][:arrdata[0].index(b"\0")].decode(
        'ascii')
    arrdata[0] = str(arrdata[0])

    return [arrdata[0]]


def extract_bank(p_bank):
    str_record = '{0}sb'.format(__MAXNAME_L__)
    str_record += '{0}s'.format(__MAXPATH_L__)
    str_record += '{0}s'.format(__MAXPATH_L__)
    str_record += '{0}s'.format(__MAXPATH_L__)

    with open(p_bank, 'rb') as f:
        b_data = f.read()

    max_games = int(len(b_data) / 219)
    arr_result = []
    for i_game in range(max_games):
        i_offset = i_game * 219
        zxdata = unpack(str_record, b_data[i_offset:i_offset + 219])
        arrdata = list(zxdata)

        arrdata[1] = str(arrdata[1])
        arr_strs = [0, 2, 3, 4]
        for i_str in arr_strs:
            arrdata[i_str] = arrdata[i_str][:arrdata[i_str].
                                            index(b"\0")].decode('ascii')

        if arrdata[0]:
            arr_result.append(arrdata)

    return arr_result


if __name__ == '__main__':
    main()
