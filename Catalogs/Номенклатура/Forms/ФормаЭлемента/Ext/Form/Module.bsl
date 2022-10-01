﻿
&НаСервере
Процедура УУ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Группа = Элементы.Добавить(
	"УпрГруппа",
	Тип("ГруппаФормы"),
	ЭтаФорма);
	
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Поведение  = ПоведениеОбычнойГруппы.Свертываемая;
	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	Группа.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
	Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
	
	Группа.Заголовок = "Реквизиты (Управленка):";
	
	ПолеВвода = Элементы.Добавить("Вес", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.Вес";
	
	ПолеВвода = Элементы.Добавить("ВесНетто", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ВесНетто";
	
	ПолеВвода = Элементы.Добавить("Объем", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.Объем";
	
	ПолеВвода = Элементы.Добавить("Кратность", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.Кратность";
	
	ПолеВвода = Элементы.Добавить("МинимальнаяПартия", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.МинимальнаяПартия";
	
	ПолеВвода = Элементы.Добавить("Весовой", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеФлажка;
	ПолеВвода.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	ПолеВвода.ПутьКДанным = "Объект.Весовой";
	
КонецПроцедуры

&НаКлиенте
Процедура УУ_ПриОткрытииПосле(Отказ)
	
	ОграничениеПрав = Бюджетныйнасервере.СправочникНайтиПоНаименованию("сабМониторВнедрения", "ОграничениеПравРедактированияКлючевыхСправочников", Истина);
	
	Если ЗначениеЗаполнено(ОграничениеПрав) И БюджетныйНаСервере.ВернутьРеквизит(ОграничениеПрав, "Значение") = "Да" Тогда
		
		Если Не БюджетныйНаСервере.РольДоступнаСервер("АдминистраторСистемы") Тогда
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
