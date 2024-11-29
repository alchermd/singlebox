import json
import math
import os
import secrets
import tarfile

import boto3

codedeploy_client = boto3.client("codedeploy")
s3_client = boto3.client("s3")


def upload_artifacts(bucket) -> tuple[str, str]:
    random_id = secrets.token_urlsafe(math.floor(32 / 1.3))
    key = f"singlebox-revision-{random_id}.tar.gz"
    with tarfile.open(key, "w:gz") as tar:
        tar.add("../src", arcname=".")

    with open(key, "rb") as tar:
        s3_client.upload_fileobj(tar, bucket, key)

    return bucket, key

def create_deployment(app_name, deployment_group_name, deployment_config_name, bucket, key):
    codedeploy_client.create_deployment(
        applicationName=app_name,
        deploymentGroupName=deployment_group_name,
        revision={
            "revisionType": "S3",
            "s3Location": {
                "bucket": bucket,
                "key": key,
                "bundleType": "tar",
            }
        },
        deploymentConfigName=deployment_config_name,
        fileExistsBehavior="OVERWRITE",
    )

def cleanup_artifacts():
    dir_name = "."
    files = os.listdir(dir_name)

    for _file in files:
        if _file.endswith(".tar.gz"):
            os.remove(os.path.join(dir_name, _file))


def main():
    with open("../terraform-output.json", "r") as f:
        output = json.load(f)

    app_name = output["codedeploy_app"]["value"]
    deployment_group_name = output["codedeploy_deployment_group"]["value"]
    deployment_config_name =output["codedeploy_config_name"]["value"]
    artifact_bucket = output["codedeploy_artifact_bucket"]["value"]

    print("Uploading artifacts...")
    bucket, key = upload_artifacts(artifact_bucket)

    print("Creating deployment...")
    create_deployment(app_name, deployment_group_name, deployment_config_name, bucket, key)

    print("Cleaning up...")
    cleanup_artifacts()

    print("Done!")


if __name__ == "__main__":
    main()
