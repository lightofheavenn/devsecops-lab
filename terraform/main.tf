provider "aws" {
  region = "us-east-1"
}

# Bucket S3 principal
resource "aws_s3_bucket" "bucket_seguro" {
  bucket = "mi-bucket-devsecops-demo-12345"
}

# Bloqueo de acceso público para el bucket principal
resource "aws_s3_bucket_public_access_block" "publico" {
  bucket                  = aws_s3_bucket.bucket_seguro.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versionado para el bucket principal
resource "aws_s3_bucket_versioning" "versionado" {
  bucket = aws_s3_bucket.bucket_seguro.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Cifrado KMS para el bucket principal
resource "aws_s3_bucket_server_side_encryption_configuration" "cifrado" {
  bucket = aws_s3_bucket.bucket_seguro.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Bucket para logs
resource "aws_s3_bucket" "log_bucket" {
  bucket = "mi-bucket-devsecops-logs-12345"
}

# Bloqueo de acceso público para el bucket de logs
resource "aws_s3_bucket_public_access_block" "publico_logs" {
  bucket                  = aws_s3_bucket.log_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versionado para el bucket de logs
resource "aws_s3_bucket_versioning" "log_versionado" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Cifrado KMS para el bucket de logs
resource "aws_s3_bucket_server_side_encryption_configuration" "cifrado_logs" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Grupo de seguridad
resource "aws_security_group" "sg_seguro" {
  name        = "sg_ssh_restringido"
  description = "Grupo de seguridad con acceso SSH restringido a red privada"
}

resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  description       = "Acceso SSH restringido a red privada"
  security_group_id = aws_security_group.sg_seguro.id
}

resource "aws_security_group_rule" "egress_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Salida HTTP"
  security_group_id = aws_security_group.sg_seguro.id
}
