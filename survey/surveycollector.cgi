#!/usr/bin/python

import json
import cgi
import time
import os

def validate_form(form):
    messages = []
    if not 'pers_time' in form or form['pers_time'].value == 'none':
        messages.append("Please indicate how much time you spend in your personal computing environment.")
    if not 'man_time' in form or form['man_time'].value == 'none':
        messages.append("Please indicate how much time you spend in a managed computing environment.")
    if not 'virt_time' in form or form['virt_time'].value == 'none':
        messages.append("Please indicate how often you use virtual machines.")
    if not 'bg_datamod' in form or not len(form.getlist('bg_datamod')):
        messages.append("Please indicate want kind of data you are working with.")
    if 'bg_datamod' in form and 'other' in form.getlist('bg_datamod') and not form['bg_datamod_other'].value:
        messages.append("You selected 'Other data modality' but did not specific which one.")
    if 'pers_maint_time' in form and form['pers_maint_time'].value:
        try:
            t = float(form['pers_maint_time'].value)
        except:
            messages.append("The value you entered as maintenance effort per month needs to be a (floating point) number. For example: 1.2 or 5")
    return messages


def format_message(mesgs):
    msg = '>>> We found a problem with your submission <<<\n\n'
    return msg + '\n\n'.join(mesgs)

def extract_results(form, result):
    # simple strings
    for ff in ["bg_country", "bg_employer", "bg_position", "bg_developer", "bg_datamod_other",
               "pers_time", "pers_hardware", "pers_os",
               "man_time", "man_hardware", "man_os",
               "virt_time", "virt_other", "virt_guest_os", "virt_host_os",
               "software_resource_other", "sw_other"]:
        if ff in form:
            result[ff] = form[ff].value
    # integers
    for ff in ["pers_r1", "pers_r2", "pers_r3", "pers_r4", "pers_r5", "pers_r6", "pers_r7", "pers_r8",
               "man_r1", "man_r2", "man_r3", "man_r4", "man_r5",
               "virt_r1", "virt_r2", "virt_r3", "virt_r4"]:
        if ff in form:
            result[ff] = int(form[ff].value)
    # lists
    for ff in ["bg_datamod", "virt_prod", "software_resource", "sw"]:
        if ff in form:
            result[ff] = form.getlist(ff)
        
    # special
    if "pers_maint_time" in form and form["pers_maint_time"].value:
        result["pers_maint_time"] = float(form["pers_maint_time"].value)

    # timestamp
    result['timestamp'] = time.time()

    # IP
    if 'REMOTE_ADDR' in os.environ:
        result['remote_addr'] = os.environ['REMOTE_ADDR']

    return result

def main():
    # list of form data keys
    formkeys = []

    # get the form data
    form = cgi.FieldStorage(keep_blank_values=True)

    # compose the server response
    result ={}
    result['success'] = False

    # Make sure we always return something meaningful 
    try:
        messages = validate_form(form)
        if not len(messages):
            # no messages means all good
            result['success'] = True
            result = extract_results(form, result)
            try:
                logfile = open('/home/neurodebian/surveydata/%s.json' % result['timestamp'], 'w+')
                logfile.write(json.write(result))
                logfile.write('\n')
                logfile.close()
            except:
                result['success'] = False
                result['message'] = 'We are very sorry, but the server is unable to store your submission. Please contact team@neuro.debian.net.'
        else:
            result['message'] = format_message(messages)

    finally:
        # always talk to the client
        print json.write(result)


if __name__ == '__main__':
    print "Content-Type: text/xhtml"    # HTML is following
    print                               # blank line, end of headers

    main()

