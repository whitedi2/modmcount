﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ТипЗнч(ПараметрыВыполненияКоманды) = Тип("Строка") Тогда
		ИмяКоманды = ПараметрыВыполненияКоманды;
	Иначе
		ИмяКоманды = Прав(ПараметрыВыполненияКоманды.НавигационнаяСсылка,СтрДлина(ПараметрыВыполненияКоманды.НавигационнаяСсылка) - 14); 
	КонецЕсли;
	
	БюджетныйНаКлиенте.УниверсальнаяПечать(ПолучитьЗаявкиСправочники(ПараметрКоманды), Истина);	
КонецПроцедуры

Функция ПолучитьЗаявкиСправочники(ПараметрКоманды)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Задача.Заявка
	|ИЗ
	|	Справочник.Задача КАК Задача
	|ГДЕ
	|	Задача.Ссылка В(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", ПараметрКоманды);
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Заявка");
КонецФункции // ()

