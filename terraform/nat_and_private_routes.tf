# Elastic IP for NAT Gateway (one NAT in first public subnet)
resource "aws_eip" "nat" {
  tags = merge(var.tags, { Name = "project8-nat-eip" })
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id  = values(aws_subnet.public)[0].id
  tags       = merge(var.tags, { Name = "project8-natgw" })
  depends_on = [aws_internet_gateway.igw]
}

# Private route table (uses NAT)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "project8-private-rt" })
}

resource "aws_route" "private_to_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
