#############
# SUMMARY files
# #############
#
outputfile="collated_SUMMARY.csv"
/bin/rm -f $outputfile
for folder in */; do
    echo " process $folder ..."
     for file in `/bin/ls $folder/SUMMARY_*.dat`; do
       echo " process $file..."
       if [ -f "$outputfile" ]; then
            tail -n +2 $file >> $outputfile
       else
            tail -n +1 $file >> $outputfile
      fi
     done
done

# #################
# DIGITSPANFW files
# #################

outputfile="collated_DIGITSPANFW.csv"
/bin/rm -f $outputfile
for folder in */; do
    echo " process $folder ..."
     for file in `/bin/ls $folder/DIGITSPANFW_summary_*.dat`; do
       echo " process $file..."
       if [ -f "$outputfile" ]; then
            tail -n +2 $file >> $outputfile
       else
            tail -n +1 $file >> $outputfile
      fi
     done
done

# #################
# DIGITSPANBW files
# #################

outputfile="collated_DIGITSPANBW.csv"
/bin/rm -f $outputfile
for folder in */; do
    echo " process $folder ..."
     for file in `/bin/ls $folder/DIGITSPANBW_summary_*.dat`; do
       echo " process $file..."
       if [ -f "$outputfile" ]; then
            tail -n +2 $file >> $outputfile
       else
            tail -n +1 $file >> $outputfile
      fi
     done
done

# ############
# GONOGO files
# ############

outputfile="collated_GONOGO.csv"
/bin/rm -f $outputfile
for folder in */; do
    echo " process $folder ..."
     for file in `/bin/ls $folder/GONOGO_summary_*.dat`; do
       echo " process $file..."
       if [ -f "$outputfile" ]; then
            tail -n +2 $file >> $outputfile
       else
            tail -n +1 $file >> $outputfile
      fi
     done
done


# ##################
# IOWAGAMBLING files
# ##################

outputfile="collated_IOWAGAMBLING.csv"
/bin/rm -f $outputfile
for folder in */; do
    echo " process $folder ..."
     for file in `/bin/ls $folder/IOWAGAMBLING_summary_*.dat`; do
       echo " process $file..."
       if [ -f "$outputfile" ]; then
            tail -n +2 $file >> $outputfile
       else
            tail -n +1 $file >> $outputfile
      fi
     done
done



# #################
# RULEFINDING files
# #################

outputfile="collated_RULEFINDING.csv"
/bin/rm -f $outputfile
for folder in */; do
    echo " process $folder ..."
     for file in `/bin/ls $folder/RULEFINDING_summary_*.dat`; do
       echo " process $file..."
       if [ -f "$outputfile" ]; then
            tail -n +2 $file >> $outputfile
       else
            tail -n +1 $file >> $outputfile
      fi
     done
done
