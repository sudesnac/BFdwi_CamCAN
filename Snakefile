import pandas as pd
df = pd.read_table('participants.tsv')
subjects = df.participant_id.to_list() 
subjects = [ s.strip('sub-') for s in subjects ]

rule gen_mean_value_txt:
    input:
        dti = 'results/sub-{subject}/ses-{session}/sub-{subject}_ses-{session}_dwi_proc-FSL_space-Hipp{hemi}_{metric}.nii.gz',
        subfields = os.path.join(config['hippunfold_dir'],'sub-{subject}/ses-{session}/hemi-{hemi}/subfields-BigBrain.nii.gz')
    params:
        hemi_letter = lambda wildcards: wildcards.hemi[0]
    output:
        csv = 'results/sub-{subject}/ses-{session}/sub-{subject}_ses-{session}_hemi-{hemi}_desc-subfields_{metric}.csv'
    container: config['singularity']['fsl']
    shell:
        "fslstats -K {input.subfields} {input.dti} -m  > {output.csv} "
