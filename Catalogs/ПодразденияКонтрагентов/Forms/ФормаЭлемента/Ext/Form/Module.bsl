﻿
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновитьДанныеВЗаказе",,?(ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("ПолеФормы"), ЭтаФорма.ВладелецФормы.ТекстРедактирования, Неопределено));
КонецПроцедуры
