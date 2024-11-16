resource "aws_docdb_cluster" "this" {
  cluster_identifier      = "avul-docdb-cluster"
  engine                  = "docdb"
  master_username         = var.docdb_master_username
  master_password         = var.docdb_master_password
  availability_zones      = var.availability_zones
  tags                    = local.common_tags
}

resource "aws_docdb_cluster_instance" "this" {
  identifier         = "docdb-cluster-demo-1"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = "db.t3.medium"
}
