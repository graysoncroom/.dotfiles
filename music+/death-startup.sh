#!/bin/bash

for i in {21..4000..1}; do
	beep -f $i -l 2000
done

for i in {4000..21..1}; do
 	beep -f $i -l 2000
done
