data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
  description = "Permitir o trafego para a Lambda"
  vpc_id      = data.aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "Security Group para Lambda" })
}

resource "aws_security_group" "docdb_sg" {
  name        = "docdb_sg"
  description = "Permite a conexao ao DocumentDB"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
  }

  tags = merge(local.common_tags, { Name = "Security Group para DocumentDB" })
}
