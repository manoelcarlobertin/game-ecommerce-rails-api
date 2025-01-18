# services/license_service.rb
class LicenseService
  def self.search(query)
    License.where('LOWER(key) LIKE :query OR LOWER(platform) LIKE :query', query: "%#{query.downcase}%")
  end

  def self.paginate(relation, page: 1, length: 10)
    page = page.to_i <= 0 ? 1 : page.to_i
    length = length.to_i <= 0 ? 10 : length.to_i

    offset = (page - 1) * length
    relation.limit(length).offset(offset)
  end
end
