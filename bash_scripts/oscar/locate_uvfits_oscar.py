#!/bin/env python

import sys
from optparse import OptionParser
import socket
import subprocess


def main():
    usage="Usage: %prog [options]\n"
    usage+="\tFinds the uvfits file location for an Observation ID"

    parser = OptionParser(usage=usage)
    parser.add_option('-o','--obsid',dest="obsid",
                      help="Observation ID")

    (options,args) = parser.parse_args()

    cmd = 'find /users/wl42/data/wl42/test/ -name \"'+options.obsid+'\".uvfits'
    out = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (stdout, stderr) = out.communicate()

    path = stdout.decode().split()[0]

    print path


if __name__=="__main__":
    main()
