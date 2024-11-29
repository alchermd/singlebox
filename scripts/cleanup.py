import json

import boto3

s3_resource = boto3.resource("s3")


def empty_bucket(bucket):
    bucket = s3_resource.Bucket(bucket)
    bucket.objects.all().delete()


def main():
    with open("../terraform-output.json", "r") as f:
        output = json.load(f)

    artifact_bucket = output["codedeploy_artifact_bucket"]["value"]
    print(f"Cleaning up {artifact_bucket}")
    empty_bucket(artifact_bucket)
    print("Done!")


if __name__ == "__main__":
    main()
