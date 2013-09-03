#!/bin/bash

for i in spec/*.rb
do
	rspec $i
done
