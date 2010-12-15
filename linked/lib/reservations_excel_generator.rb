# encoding: utf-8
class ReservationsExcelGenerator

  attr_reader :output_file_path

  def initialize(product_id)
    tmpfile = Tempfile.new("reservations")
    @output_file_path = tmpfile.path
    @product = Product.find(product_id)
    @reservations = @product.reservations.includes(:coupon)
  end

  def export_to_xls

    doc = Spreadsheet::Workbook.new

    [["used_at", "사용일자"],
     ["agency", "구매업체"],
     ["provider", "공급업체"]].each do |key, sheet_name|

      sheet = doc.create_worksheet
      sheet.name = sheet_name

      sheet = write_to_sheet(sheet, key, sheet_name)
    end

    doc.write(@output_file_path)
  end


  protected

    def write_to_sheet(sheet, group_by, group_by_text)
      grouped_reservations = @reservations.group_by(&group_by_block_statement(group_by))

      row_index = 0

      grouped_reservations.each do |key, reservations|

        sheet.row(row_index).push "#{group_by_text}: #{key}"
        row_index += 1

        sheet.row(row_index).replace %W{
          사용자명 쿠폰번호 스키장 이용일 시간대 장비 스탠스 신장 발사이즈
        }
        row_index += 1

        reservations.each do |reservation|
          sheet.row(row_index).replace [
            reservation.user_name,
            reservation.coupon.coupon_number,
            reservation.resort,
            reservation.used_at.to_date,
            reservation.part_time,
            SHOE_TYPE_OPTIONS[reservation.shoe_type] || "",
            reservation.board_stance || "",
            reservation.height,
            reservation.shoe_size
          ]
          row_index += 1
        end

        row_index += 2
      end

      sheet
    end


    def group_by_block_statement(group_by)
      case group_by
      when "agency"
        Proc.new{ |r| r.coupon.agency_name }
      when "provider"
        Proc.new{ |r| r.product.provider_name }
      else
        Proc.new{ |r| r.used_at.to_date }
      end
    end

end
