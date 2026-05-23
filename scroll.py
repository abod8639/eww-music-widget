#!/usr/bin/env python3
import sys
import time
import threading

width = 22
delay = 0.3

# Parse optional arguments
if len(sys.argv) > 1:
    try:
        width = int(sys.argv[1])
    except ValueError:
        pass
if len(sys.argv) > 2:
    try:
        delay = float(sys.argv[2])
    except ValueError:
        pass

current_text = "No Music Playing"

def read_input():
    global current_text
    for line in sys.stdin:
        current_text = line.strip()

t = threading.Thread(target=read_input, daemon=True)
t.start()

while True:
    text = current_text
    if not text:
        text = "No Music Playing"
        
    if len(text) <= width:
        print(text, flush=True)
        time.sleep(1)
    else:
        scroll_text = text + "   •   "
        scroll_len = len(scroll_text)
        for i in range(scroll_len):
            if text != current_text:
                break
            
            end_idx = i + width
            if end_idx <= scroll_len:
                out = scroll_text[i:end_idx]
            else:
                out = scroll_text[i:] + scroll_text[:end_idx - scroll_len]
            
            print(out, flush=True)
            time.sleep(delay)
