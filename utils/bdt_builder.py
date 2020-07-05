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

    bdt_data = scan_dir(arg_data['input'], arg_data['prefix'])

    if arg_data['sort']:
        str_msg = _('Sorting...')
        LOGGER.debug(str_msg)
        bdt_data = sorted(sorted(bdt_data), key=lambda x: x[0].upper())

    if bdt_data:
        with open(arg_data['output'], 'w') as f:
            if arg_data['cpath']:
                f.write(arg_data['cpath'])
            else:
                f.write(str(arg_data['input']))
            f.write('\r\n')
            writer = csv.writer(f)
            writer.writerows(bdt_data)

            str_msg = 'BDT file created at: {0}\n'
            str_msg += 'Copy it to your SD card, in the same place where '
            str_msg += 'knloader.bas, knlauncher and nkzml are located.'
            str_msg = _(str_msg)
            print(str_msg.format(arg_data['output']))

    str_msg = _('Finished.')
    LOGGER.debug(str_msg)


# Functions
# ---------


def parse_args():
    """Command Line Parser"""
    str_hlp_input = _('Path to directory')
    str_hlp_output = _('BDT file path')
    str_hlp_cpath = _('Path in SD to directory')

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
    parser.add_argument('-c',
                        '--custom',
                        action='store',
                        dest='custom_path',
                        help=str_hlp_output)
    parser.add_argument('-p', '--prefix', action='store', dest='prefix')

    arguments = parser.parse_args()

    values = {}

    i_path = None
    if arguments.input_path:
        i_path = Path(arguments.input_path)

    o_path = Path(Path.cwd(), 'knloader.bdt')
    if arguments.output_path:
        o_path = Path(arguments.output_path)

    c_path = ''
    if arguments.custom_path:
        c_path = arguments.custom_path

    str_prefix = ''
    if arguments.prefix:
        str_prefix = arguments.prefix

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
    values['cpath'] = c_path
    values['sort'] = True
    values['prefix'] = str_prefix

    return values


def scan_dir(input_dir, str_prefix):
    """Scans directories"""
    dict_exts = {
        'nex': 15,
        'snx': 16,
        'tap': 1,
        'bas': 0,
        'dsk': 3,
        'p': 16,
        'tzx': 2,
        'z8': 17,
        'z5': 17,
        'z3': 17,
        'z80': 16
    }
    arr_imgs = ['bmp', 'sl2', 'scr', 'slr', 'shr', 'shc']

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

            if str(zxdir.name) != '':
                if str(zxdir.name).upper() == '3DOS':
                    zxname = zxdir.parent.name
                else:
                    zxname = zxdir.name

            if zxname not in dict_tmp:
                dict_tmp[zxname] = {}

            if zxext in dict_exts:
                dict_tmp[zxname][zxext] = [zxdir, zxfile]

            if zxext in arr_imgs:
                dict_tmp[zxname][zxext] = [zxdir, zxfile]

    for game in dict_tmp:
        if dict_tmp[game]:
            arr_tmp = []
            zxdir = None
            for zxext in dict_exts:
                if zxext in dict_tmp[game]:
                    zxname = game
                    zxmode = dict_exts[zxext]
                    zxdir = dict_tmp[game][zxext][0]
                    zxfile = dict_tmp[game][zxext][1]

                    str_dir = str(zxdir)
                    if str_prefix:
                        str_dir = str_prefix + str_dir
                    arr_tmp = [zxname, zxmode, str_dir, zxfile]
                    break

            if arr_tmp:
                for zxext in arr_imgs:
                    if zxext in dict_tmp[game]:
                        zximg = dict_tmp[game][zxext][1]
                        if dict_tmp[game][zxext][0] != zxdir:
                            if str(dict_tmp[game][zxext][0]).startswith(
                                    str(zxdir)):
                                imgdir = Path(
                                    str(dict_tmp[game][zxext][0])
                                    [len(str(zxdir)) + 1:])
                                zximg = str(Path(imgdir, zximg))
                            else:
                                str_msg = _(
                                    'Image "{0}" ignored for program: {1}')
                                LOGGER.warning(str_msg.format(zximg, game))
                                zximg = ''

                        if zximg:
                            arr_tmp.append(zximg)
                            break

                arr_result.append(arr_tmp)

    return arr_result


if __name__ == '__main__':
    main()
