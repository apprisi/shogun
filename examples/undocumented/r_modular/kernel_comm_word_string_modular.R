library(shogun)

fm_train_dna <- as.matrix(read.table('../data/fm_train_dna.dat'))
fm_test_dna <- as.matrix(read.table('../data/fm_test_dna.dat'))

# comm_word_string
print('CommWordString')

order <- as.integer(3)
gap <- as.integer(0)
start <- as.integer(order-1)
reverse <- FALSE

charfeat <- StringCharFeatures("DNA")
dump <- charfeat$set_features(fm_train_dna)
feats_train <- StringWordFeatures(charfeat$get_alphabet())
dump <- feats_train$obtain_from_char(charfeat, start, order, gap, reverse)
preproc <- SortWordString()
dump <- preproc$init(feats_train)
dump <- feats_train$add_preproc(preproc)
dump <- feats_train$apply_preproc()

charfeat <- StringCharFeatures("DNA")
dump <- charfeat$set_features(fm_test_dna)
feats_test <- StringWordFeatures(charfeat$get_alphabet())
dump <- feats_test$obtain_from_char(charfeat, start, order, gap, reverse)
dump <- feats_test$add_preproc(preproc)
dump <- feats_test$apply_preproc()

use_sign <- FALSE

kernel <- CommWordStringKernel(feats_train, feats_train, use_sign)

km_train <- kernel$get_kernel_matrix()

kernel <- CommWordStringKernel(feats_train, feats_test, use_sign)
km_test <- kernel$get_kernel_matrix()
