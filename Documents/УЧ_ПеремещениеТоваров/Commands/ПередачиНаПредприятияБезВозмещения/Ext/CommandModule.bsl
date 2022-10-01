﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура;
	ТекФорма = ПолучитьФорму("Документ.УЧ_ПеремещениеТоваров.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ПеремещениеНаПредприятиеБезВозмещения", ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	НовыйОтбор = ТекФорма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидОперации");
	НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НовыйОтбор.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.ВидыПеремещений.ПеремещениеНаПредприятиеБезВозмещения");
	
	ТекФорма.Открыть();
КонецПроцедуры
