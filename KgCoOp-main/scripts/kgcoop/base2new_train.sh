#!/bin/bash

cd ../..

# custom config
DATA=/data/yht/data/cl/data
TRAINER=KgCoOp

DATASET=$1
WEIGHT=$2

CFG=vit_b16_ep100_ctxv1
SHOTS=16


for SEED in 1 2 3
do
	DIR=output/base2new/train_base/${DATASET}/shots_${SHOTS}/${TRAINER}/${CFG}/seed${SEED}
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
    		DATASET.NUM_SHOTS ${SHOTS} \
    		TRAINER.COOP.W ${WEIGHT} \
    		DATASET.SUBSAMPLE_CLASSES base
	fi
done
