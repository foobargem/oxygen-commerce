# encoding: utf-8
class ReservationsExcelGenerator

  attr_reader :output_file_path

  def initialize(reservations)
    tmpfile = Tempfile.new("reservations")
    @output_file_path = tmpfile.path
    @reservations = reservations

    @default_header_format = Spreadsheet::Format.new(:align => :center, :color => :gray)
    @default_content_format = Spreadsheet::Format.new(:align => :center)
  end

  def export_to_xls
    doc = Spreadsheet::Workbook.new

    [["used_at", "사용일자"],
     ["agency", "판매업체"],
     ["product", "상품명"],
     ["resort", "스키장"]
    ].each do |groupby, sheet_name|

      sheet = doc.create_worksheet
      sheet.name = sheet_name

      sheet = write_to_sheet(sheet, sheet_name, groupby)
    end

    doc.write(@output_file_path)
  end


  protected

    def write_to_sheet(sheet, sheet_name, groupby)
      grouped_reservations = @reservations.group_by(&group_by_block_statement(groupby))

      row_index = 0

      grouped_reservations.each do |key, reservations|

        unless groupby == "resort"
          sheet.row(row_index).push "#{sheet_name}: #{key}"
        else
          sheet.row(row_index).push "#{sheet_name}: #{RESORT_OPTIONS[key]}"
        end

        row_index += 1

        sheet.row(row_index).replace %W{
          예약자명 연락처 쿠폰번호 스키장 이용일 시간대 사용자명 장비 장비옵션 신장 신발크기
        }
        sheet.row(row_index).default_format = @default_header_format
        row_index += 1

        reservations.each do |reservation|
          reservation.orders.each do |order|
            sheet.row(row_index).replace [
              reservation.subscriber_name,
              reservation.coupon.phone_number || "",
              (reservation.coupon.nil? ? "삭제된쿠폰" : reservation.coupon.coupon_number),
              RESORT_OPTIONS[reservation.resort],
              reservation.used_at.to_date,
              reservation.part_time,
              order.user_name,
              SHOE_TYPE_OPTIONS[order.shoe_type] || "",
              order.board_stance || "",
              order.height,
              order.shoe_size
            ]
            sheet.row(row_index).default_format = @default_content_format
            row_index += 1
          end
        end

        row_index += 2
      end

      sheet
    end


    def group_by_block_statement(group_by)
      block = case group_by
              when "agency"
                Proc.new{ |r| r.coupon.agency_name }
              when "product"
                Proc.new{ |r| r.product.name }
              when "resort"
                Proc.new{ |r| r.resort }
              else
                Proc.new{ |r| r.used_at.to_date }
              end
      block
    end

end
