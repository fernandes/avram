require "../spec_helper"

describe "Avram::QueryBuilder#merge" do
  it "merges the wheres and joins" do
    query_1 = new_query
      .where(Avram::Where::Equal.new(:age, "42"))
      .raw_where(Avram::Where::Raw.new("name = ?", "Mary"))
      .join(Avram::Join::Inner.new(:users, :posts))
    query_2 = new_query
      .where(Avram::Where::Equal.new(:age, "20"))
      .raw_where(Avram::Where::Raw.new("name = ?", "Greg"))
      .join(Avram::Join::Inner.new(:users, :tasks))

    query_1.merge(query_2)

    query_1.statement.should eq "SELECT * FROM users INNER JOIN posts ON users.id = posts.user_id INNER JOIN tasks ON users.id = tasks.user_id WHERE age = $1 AND age = $2 AND name = 'Mary' AND name = 'Greg'"
    query_1.args.should eq ["42", "20"]
  end

  it "merges orders" do
    query_1 = new_query
      .order_by(:id, :asc)
    query_2 = new_query
      .order_by(:name, :desc)

    query_1.merge(query_2)
    query_1.statement.should contain "ORDER BY id ASC, name DESC"
  end
end

private def new_query
  Avram::QueryBuilder.new(table: :users)
end
