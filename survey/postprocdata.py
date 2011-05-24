#!/usr/bin/python
#emacs: -*- mode: python-mode; py-indent-offset: 4; tab-width: 4; indent-tabs-mode: nil -*- 
#ex: set sts=4 ts=4 sw=4 noet:
#------------------------- =+- Python script -+= -------------------------
"""
 @file      postprocdata.py
 @date      Tue May 24 10:28:28 2011
 @brief


  Yaroslav Halchenko                                            Dartmouth
  web:     http://www.onerussian.com                              College
  e-mail:  yoh@onerussian.com                              ICQ#: 60653192

 DESCRIPTION (NOTES):

 COPYRIGHT: Yaroslav Halchenko 2011

 LICENSE: MIT

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
"""
#-----------------\____________________________________/------------------

__author__ = 'Yaroslav Halchenko'
__revision__ = '$Revision: $'
__date__ = '$Date:  $'
__copyright__ = 'Copyright (c) 2011 Yaroslav Halchenko'
__license__ = 'GPL'


import os, sys, glob, json, re
from copy import copy
from mvpa.base import verbose
verbose.level = 4
datain = 'data'
dataout = 'dataout'
dataorig = 'dataorig'

blacklist = ['1305808539.9.json', '1305808540.1.json', '1305808541.03.json', # persistent and curious mind-ware guy from Israel
             ]

all_subs = dict(
    sw_other_name=dict(
        sw_electro=dict(
            cedspike='ced *spike2*',                        # NEW: http://www.ced.co.uk/pru.shtml?spk4wglu.htm
            datariver='exp control: datariver',             # NEW: http://sccn.ucsd.edu/wiki/DataSuite
            eeglab='(eeglab|http://sccn.ucsd.edu/eeglab/)',
            emse='emse',                                    # REFRESH
            erplab='erplab',                                # NEW:     ERPLAB
            klusters='klusters.*',                          # REFRESH
            netstation='egi net station',                   # NEW:     EGI Net Station
            neuroscan='(curry|neuroscan(| curry))',         # REFRESH
            neuroscope='.*neuroscope',                      # REFRESH
            nutmeg='.*nutmeg',                              # NEW
            ),
        sw_img=dict(
            mricron='mricrogl',
            afni='afni for bci',
            dtistudio='dti-*studio',    # NEW: or MRIStudio?
            brainsight='brainsight',    # NEW: BrainSight
            nordicice='nordic ice',     # NEW: NordicICE  -- just 1
            trackvis='trackvis',
            xmedcon='xmedcon',          # NEW
            ),
        sw_general=dict(
            lua='lua',                  # NEW
            stata='stata',              # NEW
            statistica='statistica',    # NEW
            java='java',                # REFRESH
            ),
        sw_neusys=dict(
            neuroml='neuroml',          # NEW: NeuroML -- more of a framework/standard than software
            xpp='xpp(|y|aut)',        # REFRESH: XPP/XPPAUT and Python interface
            ),
        sw_psychphys=dict(
            asf='asf',                  # NEW: ASF  http://code.google.com/p/asf/
            cogent='cogent(|2000)',     # REFRESH
            crsvsg='crs toolbox.*',     # NEW: CRS VSG Toolbox  http://www.crsltd.com/catalog/vsgtoolbox/
            mindware='mind-ware',       # NEW: MindWare
            nordicaktiva='nordic aktiva', # NEW:    NordicActiva  -- just 1 http://www.nordicneurolab.com/Products_and_Solutions/Clinical_Software_Solutions/nordicActiva.aspx  http://www.nordicneurolab.com/Products_and_Solutions/Clinical_Software_Solutions/nordicAktiva.aspx
            superlab='superlab',        # REFRESH
            psignifit='psignifit(|3)',  # NEW
            ),
        ignore=dict(ignore=
                    '(zsh vim mutt git'
                    # just ignore
                    '|my overall time.*|separate work.*|60% windows'
                    '|.*my own .*software'
                    # Different generic visualization solutions
                    '|gnupot|.*gnu plot.*xmgrace|mayavi|matplotlib'
                    '|trackvis'
                    '|opengl|itk|vtk'
                    '|paraview'
                    # Really cool one for graphs
                    '|gephi'
                    # Generic DBs
                    '|mysql|postgresql'
                    # DB with imaging data (Italy?) but just once
                    '|loris multi-site database system'
                    # More languages/platforms?
                    '|.net|haskel|gsl|cuda'
                    # Python lovers
                    '|theano|pygame|numpy|mdp|joblib|scipy|pytables|sympy'
                    # ML toolboxes
                    '|scikits-learn|probid .*'
                    # Reference managers
                    '|mendeley|jabref'
                    # Python IDE?? quite nice btw
                    '|spyder'
                    # Move into survey?
                    '|.*magnetic source locator.*' # Some kind of MEG inverse solver -- publications but no public project
                    ')'
                    ),
        ),
    )

for d in dataout, dataorig:
    if os.path.exists(d):
        shutil.rmtree(d)
    os.makedirs(d)

unhandled = {}
refreshed = {}
infiles = glob.glob(os.path.join(datain, '*.json'))
skipped = 0
#infiles = glob.glob(os.path.join(datain, '1305741725.57.json'))
for f in infiles:
    fname = os.path.basename(f)
    if fname in blacklist:
        verbose(1, "Skipping %s because of blacklist" % f)
        skipped += 1
        continue

    verbose(5, "Loading %s" % f)
    j = json.load(open(f))
    json.dump(j, open(os.path.join(dataorig, fname), 'w'), indent=2)
    for ofield, osubs in all_subs.iteritems():
        if not (ofield in j and j[ofield]):
            continue
        csv = j[ofield]
        values = [x.strip().lower() for x in re.split('[+,|;]', csv)]
        values = [v for v in values if len(v)]
        original_values = values[:]
        verbose(3, "Working on %s: %r" % (ofield, values))
        for sfield, ssubs in osubs.iteritems():
            srecord = copy(j.get(sfield, []))
            old_srecord = j.get(sfield, [])
            for name, regex in ssubs.iteritems():
                for i, v in enumerate(values):
                    if v is not None and re.match(regex, v):
                        # Found a match -- need to adjust the record
                        # and replace with None in values
                        values[i] = None
                        if name in old_srecord:
                            verbose(1, "Value %s is already in %s=%s" % (v, sfield, old_srecord))
                        else:
                            verbose(4, "Adding value %s for %s to %s" % (v, name, sfield))
                            srecord.append(name)
                        if sfield == 'ignore':
                            # unhandled[v] = unhandled.get(v, 0) + 1
                            pass
                        else:
                            refreshed[name] = refreshed.get(name, 0) + 1
            values = [v for v in values if v is not None]
            if sfield == 'ignore':
                verbose(4, "Skipping ignore")
                continue
            if srecord != old_srecord:
                verbose(4, "Adjusting %s to %s" % (old_srecord, srecord))
                j[sfield] = srecord
        if len(values):
            verbose(4, "Left unhandled: %s" % (values,))
            for v in values:
                unhandled[v] = unhandled.get(v, 0) + 1
    verbose(3, "Storing file %s" % fname)
    json.dump(j, open(os.path.join(dataout, fname), 'w'), indent=2)
    #open(os.path.join(dataout, fname), 'w').write(json.write(j))

def ppd(d):
    keys = sorted(d.keys())
    return '\n '.join(["%s: %d" % (k, d[k]) for k in keys])

verbose(1, "=== Refreshed ===\n %s" % ppd(refreshed))
verbose(1, "=== Unhandled ===\n %s" % ppd(unhandled))
verbose(1, "=== Skipped: %d" % skipped)
