#!/usr/bin/python
#emacs: -*- mode: python-mode; py-indent-offset: 4; tab-width: 4; indent-tabs-mode: nil -*- 
#ex: set sts=4 ts=4 sw=4 noet:
#------------------------- =+- Python script -+= -------------------------
"""
 @file      common.py
 @date      Tue Jun  7 09:22:57 2011
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
__copyright__ = 'Copyright (c) 2011 Yaroslav Halchenko'
__license__ = 'MIT'

# Each tuple here is a (regular expression for "Others", either it was newly added while survey was on already)
entries_to_refresh = dict(
    sw_other_name=dict(
        sw_electro=dict(
            brainsuite=('brainsuite', True),                # EARLYIN
            cedspike=('ced *spike2*', True),                # NEW: http://www.ced.co.uk/pru.shtml?spk4wglu.htm
            datariver=('exp control: datariver', True),     # NEW: http://sccn.ucsd.edu/wiki/DataSuite
            eeglab=('(eeglab|http://sccn.ucsd.edu/eeglab/)', False),
            emse=('emse', True),                            # REFRESH  EARLYIN
            erplab=('erplab', True),                        # NEW:     ERPLAB
            klusters=('klusters.*', True),                  # REFRESH
            netstation=('egi net station', True),           # NEW:     EGI Net Station
            neuroscan=('(curry|neuroscan(| curry))', True), # REFRESH
            neuroscope=('.*neuroscope', True),              # REFRESH
            nutmeg=('.*nutmeg', True),                      # NEW
            ndmanager=('ndmanager', True),                  # EARLYIN
            fmatoolbox=('FMAToolbox', True),                # EARLYIN
            ),
        sw_img=dict(
            mricron=('mricrogl', False),
            afni=('afni for bci', False),
            dtistudio=('dti-*studio', True),    # NEW: or MRIStudio?
            brainsight=('brainsight', True),    # NEW: BrainSight
            nordicice=('nordic ice', True),     # NEW: NordicICE  -- just 1
            trackvis=('trackvis', False),
            xmedcon=('xmedcon', True),          # NEW
            ),
        sw_general=dict(
            lua=('lua', True),                  # NEW
            stata=('stata', True),              # NEW
            statistica=('statistica', True),    # NEW
            java=('java', True),                # REFRESH
            fortran=('fortran', True),          # EARLYIN
            ),
        sw_neusys=dict(
            ecanse=('ecanse', True),            # EARLYIN
            emergent=('emergent', True),        # EARLYIN
            nengo=('nengo', True),              # EARLYIN
            neuroml=('neuroml', True),          # NEW: NeuroML -- more of a framework/standard than software
            neurosolutions=('neurosolutions', True), # EARLYIN
            peltarion=('peltarion', True),           # EARLYIN
            snnap=('snnap', True),              # EARLYIN
            snns=('snns', True),                # EARLYIN
            xnbc=('xnbc', True),                # EARLYIN
            xpp=('xpp(|y|aut)', True),          # REFRESH: XPP/XPPAUT and Python interface
            ),
        sw_psychphys=dict(
            asf=('asf', True),                  # NEW: ASF  http://code.google.com/p/asf/
            cogent=('cogent(|2000)', True),     # REFRESH
            crsvsg=('crs toolbox.*', True),     # NEW: CRS VSG Toolbox  http://www.crsltd.com/catalog/vsgtoolbox/
            mindware=('mind-ware', True),       # NEW: MindWare
            nordicaktiva=('nordic aktiva', True), # NEW:    NordicActiva  -- just 1 http://www.nordicneurolab.com/Products_and_Solutions/Clinical_Software_Solutions/nordicActiva.aspx  http://www.nordicneurolab.com/Products_and_Solutions/Clinical_Software_Solutions/nordicAktiva.aspx
            superlab=('superlab', True),        # REFRESH
            psignifit=('psignifit(|3)', True),  # NEW
            ),
        ignore=dict(ignore=(
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
                    ')', True)
                    ),
        ),
    )
