#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- mode: Python; tab-width: 4; indent-tabs-mode: nil; -*-
# Do not change the previous lines. See PEP 8, PEP 263.
"""
knloader BDT File Automatic Builder

    Copyright (c) 2020-2022 @Kounch

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
from pathlib import Path

__MY_NAME__ = 'bdt_builder.py'
__MY_VERSION__ = '2.1'

DICT_EXTS = {
    'nex': 15,
    'snx': 16,
    'tap': 1,
    'bas': 0,
    'dsk': 3,
    'p': 16,
    'tzx': 2,
    'pzx': 33,
    'z8': 17,
    'z5': 17,
    'z3': 17,
    'z80': 16
}
ARR_IMGS = ['bmp', 'sl2', 'scr', 'slr', 'shr', 'shc']

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

    bdt_data = scan_dir(arg_data['input'], arg_data['prefix'],
                        arg_data['detection'], arg_data['shortnames'])

    if arg_data['sort']:
        str_msg = _('Sorting...')
        LOGGER.debug(str_msg)
        bdt_data = sorted(sorted(bdt_data), key=lambda x: x[0].upper())

    if bdt_data:
        with open(arg_data['output'], 'w', newline="\n") as f:
            str_path = str(arg_data['input'])
            if arg_data['cpath']:
                str_path = arg_data['cpath']
            str_path = str_path.replace('\\', '/')
            if str_path[:-1] == '/':
                str_path = str_path[:-1]
            if len(str_path) > 1 and str_path[1] == ':':
                str_path = str_path[2:]
            if str_path == '.':
                str_path = ''
            if not str_path:
                str_path = '/'
            f.write('{0}\r\n'.format(str_path))
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
    str_hlp_detection = _('Detection mode')
    str_hlp_unsort = _('Do not sort results')
    str_hlp_short = _('Use short (8.3) DOS names')
    str_hlp_tapmode = _('TAP loading mode')
    str_hlp_tzxmode = _('TZX loading mode')
    str_hlp_pzxmode = _('PZX loading mode')
    str_hlp_basmode = _('BAS loading mode')

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
                        help=str_hlp_cpath)
    parser.add_argument('-d',
                        '--detection',
                        action='store',
                        dest='det_mode',
                        help=str_hlp_detection)
    parser.add_argument('-u',
                        '--unsorted',
                        action='store_false',
                        dest='sort_mode',
                        help=str_hlp_unsort)
    parser.add_argument('-s',
                        '--short',
                        action='store_true',
                        dest='short_filenames',
                        help=str_hlp_short)
    parser.add_argument('--tap',
                        action='store',
                        dest='tap_mode',
                        help=str_hlp_tapmode)
    parser.add_argument('--tzx',
                        action='store',
                        dest='tzx_mode',
                        help=str_hlp_tzxmode)
    parser.add_argument('--pzx',
                        action='store',
                        dest='pzx_mode',
                        help=str_hlp_pzxmode)
    parser.add_argument('--bas',
                        action='store',
                        dest='bas_mode',
                        help=str_hlp_basmode)
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

    det_mode = 'f'
    if arguments.det_mode:
        det_mode = arguments.det_mode

    sort_mode = arguments.sort_mode

    shortnames = arguments.short_filenames

    if arguments.tap_mode:
        DICT_EXTS['tap'] = int(arguments.tap_mode)

    if arguments.tzx_mode:
        DICT_EXTS['tzx'] = int(arguments.tzx_mode)

    if arguments.pzx_mode:
        DICT_EXTS['pzx'] = int(arguments.pzx_mode)

    if arguments.bas_mode:
        DICT_EXTS['bas'] = int(arguments.bas_mode)

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
    values['detection'] = det_mode
    values['sort'] = sort_mode
    values['shortnames'] = shortnames
    values['prefix'] = str_prefix

    return values


def scan_dir(input_dir, str_prefix, str_detection, b_sfn=False):
    """Scans directories"""
    input_dir = input_dir.resolve()
    rootlen = len(str(input_dir))
    dict_tmp = {}
    arr_result = []

    for child in sorted(input_dir.glob('**/*.*')):
        orig_path = Path(input_dir, child)
        child_path = orig_path
        if (b_sfn):
            child_path = shorten_path(input_dir, orig_path)

        if child_path.is_file():
            orig_subpath = Path(str(orig_path)[rootlen:])
            subpath = Path(str(child_path)[rootlen:])
            zxname = orig_subpath.name[:-len(subpath.suffix)]
            orig_zxdir = orig_subpath.parent
            zxdir = subpath.parent
            zxfile = subpath.name
            zxext = subpath.suffix[1:].lower()

            if ',' in str(child_path):
                str_msg = _('Invalid character in path: {0}')
                LOGGER.warning(str_msg.format(str(child_path)))
            else:
                if str_detection == 'd':
                    if str(zxdir.name) != '':
                        if str(zxdir.name).upper() == '3DOS':
                            zxname = orig_zxdir.parent.name
                        else:
                            zxname = orig_zxdir.name

                if len(zxname) > 21:
                    zxname = zxname[:21]

                if zxname not in dict_tmp:
                    dict_tmp[zxname] = {}

                if zxext in DICT_EXTS:
                    dict_tmp[zxname][zxext] = [zxdir, zxfile]

                if zxext in ARR_IMGS:
                    dict_tmp[zxname][zxext] = [zxdir, zxfile]

    for game in dict_tmp:
        if dict_tmp[game]:
            arr_tmp = []
            zxdir = None
            for zxext in DICT_EXTS:
                if zxext in dict_tmp[game]:
                    zxname = game
                    zxmode = DICT_EXTS[zxext]
                    zxdir = dict_tmp[game][zxext][0]
                    zxfile = dict_tmp[game][zxext][1]

                    str_dir = str(zxdir)
                    if str_prefix:
                        str_dir = str_prefix + str_dir

                    str_dir = str_dir.replace('\\', '/')
                    if str_dir[0] == '/':
                        str_dir = str_dir[1:]
                    if str_dir == '.':
                        str_dir = ''
                    zxfile = zxfile.replace('\\', '/')
                    arr_tmp = [zxname, zxmode, str_dir, zxfile]
                    break

            if arr_tmp:
                for zxext in ARR_IMGS:
                    if zxext in dict_tmp[game]:
                        zximg = dict_tmp[game][zxext][1]
                        zximgdir = dict_tmp[game][zxext][0]
                        if zximgdir != zxdir:
                            if str(zximgdir).startswith(str(zxdir)):
                                imgdir = Path(
                                    str(zximgdir)[len(str(zxdir)) + 1:])
                                zximg = str(Path(imgdir, zximg))
                            else:
                                str_msg = _(
                                    'Image "{0}" ignored for program: {1}')
                                LOGGER.warning(str_msg.format(zximg, game))
                                zximg = ''

                        if zximg:
                            zxmig = zximg.replace('\\', '/')
                            arr_tmp.append(zximg)
                            break

                arr_result.append(arr_tmp)

    return arr_result


def shorten_path(root_dir, lfn_path):
    """Convert subpath to 8.3 names"""
    i = 0
    for i in range(1, len(root_dir.parts)):
        if lfn_path.parts[i] != root_dir.parts[i]:
            LOGGER.error("Inconsistency error")
            return lfn_path

    lfn_subpath = lfn_path.parts[i + 1:]
    final_path = root_dir
    for lfn_element in lfn_subpath:
        tmp_path = Path(final_path, lfn_element)
        tmp_path = shorten_element(tmp_path)
        final_path = Path(final_path, tmp_path.name)

    return final_path


def shorten_element(lfn_path):
    """Convert file or dir name to 8.3 (brute force)"""
    s_remove = ' "/[]:;=,.'
    s_replace = '+'
    b_convert = False
    s_name = lfn_path.stem
    s_extension = lfn_path.suffix

    if s_name[0] == '.':
        s_name = s_name[1:]
        b_convert = True

    for c_remove in s_remove:
        if c_remove in s_name:
            s_name = s_name.replace(c_remove, '')
            b_convert = True

    for c_replace in s_replace:
        if c_replace in s_name:
            s_name = s_name.replace(c_replace, '_')
            b_convert = True

    if len(s_extension) > 4:
        s_extension = s_extension[:4]
        b_convert = True

    short_paths = shorten_name(s_name[:6], s_extension)
    short_paths += shorten_name(s_name[:5], s_extension)

    short_path = lfn_path
    for n_name in short_paths:
        test_path = Path(lfn_path.parent, n_name)

        if test_path.exists():
            short_path = test_path
            break
        else:
            LOGGER.debug("Not found: {0}".format(short_path))

    if b_convert:
        LOGGER.debug('Converted: {0}'.format(short_path))
        if short_path == lfn_path:
            LOGGER.error("Not found: {0}".format(lfn_path))

    return short_path


def shorten_name(n_name, s_extension):
    """Builds a list of candidate short 8.3 names with index"""
    l_names = []
    for i_index in range(1, 6):
        t_name = '{0}~{1}'.format(n_name, i_index)
        if s_extension:
            t_name += s_extension
        t_name = t_name.upper()
        l_names.append(t_name)

    return l_names


if __name__ == '__main__':
    main()
