#!/usr/bin/env bash
#
# Perform st_dicom_to_nifti on multiple folders and store the NIfTI files in BIDS format.
#
# The script takes in an argument on the command line to where a folder of folders of DICOMs is located. The script
# will run st_dicom_to_nifti on each folder inside the folder of the first argument and use their name to differentiate
# them in the output. It will output in the output folder (2nd argument) in BIDS format.
#
# Example:
# sh batch_dicom_to_nifti.sh input_folder output_folder
#
#
# Input folder structure:
# input_folder/
# input_folder/subject1/
# input_folder/subject2/
#
# Output folder structure
# output_folder/bids_folder/sub-subject1/...
# output_folder/bids_folder/sub-subject2/...
#
# Note:
# If you do not see your data in the above mentioned folders, they should be located in
# output_folder/bids_folder/tmp_dcm2bids/sub-... If that is the case, the issue is that st_dicom_to_nifti requires a BIDS
# config file to correctly output the NIfTI files in the appropriate folders. To fix the problem, you can modify the
# config file by first locating it ("st_dicom_to_nifti -h" and looking for the option --config) and changing it to
# correctly parse your data. More information can be found here: https://unfmontreal.github.io/Dcm2Bids/docs/how-to/create-config-file/

# Create the absolute path out of the input provided to the script
INPUT_PATH="$(cd "$(dirname "${1}")" || exit; pwd)/$(basename "${1}")"

# Create the absolute path out of the input provided to the script
OUTPUT_PATH="$(cd "$(dirname "${2}")" || exit; pwd)/$(basename "${2}")"

# Run st_dicom_to_nifti on each folder
for FNAME in "${INPUT_PATH}/"*; do
  if [[ -d "${FNAME}" && ! -L "${FNAME}" ]]; then

    echo "Processing: ${FNAME}"
    BASENAME="$(basename "${FNAME}")"
    st_dicom_to_nifti -i "${FNAME}" -o "${OUTPUT_PATH}/bids_folder" --subject "${BASENAME}" || exit

  fi
done

echo -e "\n\033[0;32mOutput is located here: ${OUTPUT_PATH}/bids_folder"
