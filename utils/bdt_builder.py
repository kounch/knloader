#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- mode: Python; tab-width: 4; indent-tabs-mode: nil; -*-
# Do not change the previous lines. See PEP 8, PEP 263.
"""
knloader BDT File Automatic Builder

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
import csv

try:
    from pathlib import Path
except (ImportError, AttributeError):
    from pathlib2 import Path

__MY_NAME__ = 'bdt_builder.py'
__MY_VERSION__ = '0.8'

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.DEBUG)
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
    LOGGER.info(str_msg)

    bdt_data = scan_dir(arg_data['input'])

    if bdt_data:
        with open(arg_data['output'], 'w') as f:
            f.write(str(arg_data['input']))
            f.write('\n')
            writer = csv.writer(f)
            writer.writerows(bdt_data)

    str_msg = _('Finished.')
    LOGGER.info(str_msg)


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


def scan_dir(input_dir):
    """Scans directories"""
    dict_exts = {'nex': 15, 'tap': 1, 'bas': 0, 'dsk': 3, 'tzx': 2, 'z3': 17}
    arr_imgs = ['bmp', 'scr']

    input_dir = input_dir.resolve()
    rootlen = len(str(input_dir))
    dict_tmp = {}
    arr_result = []
    for child in sorted(input_dir.glob('**/*.*')):
        child_path = Path(input_dir, child)
        if child_path.is_file():
            subpath = Path(str(child_path)[rootlen + 1:])
            zxname = subpath.name[:-len(subpath.suffix)]
            zxdir = subpath.parent
            zxfile = subpath.name
            zxext = subpath.suffix[1:].lower()

            if ',' in str(child_path):
                str_msg = _('Invalid character in path: {0}')
                LOGGER.error(str_msg.format(str(child_path)))
                str_msg = _('Invalid Char!')
                raise IOError(str_msg)

            if str(zxdir.parent) == '.' and str(zxdir.name) != '':
                zxname = zxdir.name
            if str(zxdir.name).upper() == '3DOS':
                if str(zxdir.parent.parent) == '.' and str(
                        zxdir.parent.name) != '':
                    zxname = zxdir.parent.name

            if zxname not in dict_tmp:
                dict_tmp[zxname] = {}

            if zxext in dict_exts:
                dict_tmp[zxname][zxext] = [zxdir, zxfile]

            if zxext in arr_imgs:
                dict_tmp[zxname][zxext] = [zxdir, zxfile]

    for game in dict_tmp:
        if dict_tmp[game]:
            arr_tmp = []
            for zxext in dict_exts:
                if zxext in dict_tmp[game]:
                    zxname = game
                    zxmode = dict_exts[zxext]
                    zxdir = dict_tmp[game][zxext][0]
                    zxfile = dict_tmp[game][zxext][1]

                    arr_tmp = [zxname, zxmode, str(zxdir), zxfile]
                    break

            if arr_tmp:
                for zxext in arr_imgs:
                    if zxext in dict_tmp[game]:
                        arr_tmp.append(dict_tmp[game][zxext][1])
                        break

                arr_result.append(arr_tmp)

    return arr_result


if __name__ == '__main__':
    main()
