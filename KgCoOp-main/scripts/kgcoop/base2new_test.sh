#!/bin/bash

cd ../..

# custom config
DATA=/data/yht/data/cl/data
TRAINER=KgCoOp

DATASET=$1

CFG=vit_b16_ep100_ctxv1
# CFG=vit_b16_ctxv1  # uncomment this when TRAINER=CoOp
SHOTS=16
LOADEP=100
SUB=new


for SEED in 1 2 3
do 
	COMMON_DIR=${DATASET}/shots_${SHOTS}/${TRAINER}/${CFG}/seed${SEED}
	MODEL_DIR=output/base2new/train_base/${COMMON_DIR}
	DIR=output/base2new/test_${SUB}/${COMMON_DIR}
	if [ -d "$DIR" ]; then
    		echo "Oops! The results exist at ${DIR} (so skip this job)"
	else
    		python train.py \
    		--root ${DATA} \
    		--seed ${SEED} \
    		--trainer ${TRAINER} \
    		--dataset-config-file configs/datasets/${DATASET}.yaml \
    		--config-file configs/trainers/${TRAINER}/${CFG}.yaml \
    		--output-dir ${DIR} \
    		--model-dir ${MODEL_DIR} \
    		--load-epoch ${LOADEP} \
    		--eval-only \
    		DATASET.NUM_SHOTS ${SHOTS} \
    		DATASET.SUBSAMPLE_CLASSES ${SUB}
	fi
done
