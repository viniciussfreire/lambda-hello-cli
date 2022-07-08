#====================================================#
# CREATE AN LAMBDA FUNCTION WITHOUT FRAMEWORK IN AWS #
#----------------------------------------------------#
# Create security role
aws iam create-role \
    --role-name lambda-example \
    --assume-role-policy-document file://configs/security-policy.json \
    | tee logs/role.log

# ZIP souce code
zip function.zip index.js

# Create lambda function
aws lambda create-function \
    --function-name hello-cli \
    --zip-file fileb://function.zip \
    --handler index.handler \
    --runtime nodejs12.x \
    --role arn:aws:iam::656137752627:role/lambda-example \
    | tee logs/lambda-create.log

# Invoke lambda
aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda-exec.log

# Update lambda
zip function.zip index.js

aws lambda update-function-code \
    --function-name hello-cli \
    --zip-file fileb://function.zip \
    --publish \
    | tee logs/lambda-update.log

# Invoke lambda
aws lambda invoke \
    --function-name hello-cli \
    --log-type Tail \
    logs/lambda-exec-update.log

# Remove function
aws lambda delete-function \
    --function-name hello-cli

# Remove role
aws iam delete-role \
    --role-name lambda-example