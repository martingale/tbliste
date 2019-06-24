#!/bin/env python3.6

import pandas as pd
import sys

tmp = pd.read_excel(sys.argv[1])
tmp = tmp.replace(r'\n',' ', regex=True) 
tmp.to_csv(sys.argv[2], sep=';', index=False)
