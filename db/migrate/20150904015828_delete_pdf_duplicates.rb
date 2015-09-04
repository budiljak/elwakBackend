class DeletePdfDuplicates < ActiveRecord::Migration
  def change
    PdfDatei.group(:objekt_id, :art, :name).having('count(id) > 1').each do |p|
      puts 'Dokument "' + p.name + '" ist mehrfach vorhanden und wird bereinigt...'
      last = PdfDatei.where(objekt_id: p.objekt_id, art: p.art, name: p.name).order(:updated_at).last
      PdfDatei.where(objekt_id: p.objekt_id, art: p.art, name: p.name).where.not(id: last.id).each do |p_del|
        id = p_del.id
        p_del.destroy
        puts 'Dokument mit id ' + id.to_s + ' gelöscht.'
      end
    end
  end
end
