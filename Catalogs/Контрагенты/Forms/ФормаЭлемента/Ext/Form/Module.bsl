﻿
&НаКлиенте
Процедура УУ_ПриОткрытииПосле(Отказ)
	
	ОграничениеПрав = Бюджетныйнасервере.СправочникНайтиПоНаименованию("сабМониторВнедрения", "ОграничениеПравРедактированияКлючевыхСправочников", Истина);
	
	Если ЗначениеЗаполнено(ОграничениеПрав) И БюджетныйНаСервере.ВернутьРеквизит(ОграничениеПрав, "Значение") = "Да" Тогда
		
		Если Не БюджетныйНаСервере.РольДоступнаСервер("АдминистраторСистемы") Тогда
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УУ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)

	Группа = Элементы.Добавить(
	"УпрГруппа",
	Тип("ГруппаФормы"),
	ЭтаФорма);
	
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Поведение  = ПоведениеОбычнойГруппы.Свертываемая;
	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	Группа.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
	Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
	
	Группа.Заголовок = "Реквизиты (Управленка):";
	
	ПолеВвода = Элементы.Добавить("ПриоритетныйПорядокРасчетов", Тип("ПолеФормы"), Группа);
	ПолеВвода.Заголовок = "Приоритетный порядок расчетов";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ПриоритетныйПорядокРасчетов"; 
	
	ПолеВвода = Элементы.Добавить("СтатусКлиента", Тип("ПолеФормы"), Группа);
	ПолеВвода.Заголовок = "Статус клиента";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.СтатусКлиента"; 
	
	ПолеВвода = Элементы.Добавить("КатегорияКлиента", Тип("ПолеФормы"), Группа);
	ПолеВвода.Заголовок = "Категория клиента";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.КатегорияКлиента"; 
	
	ПолеВвода = Элементы.Добавить("СкладОтгрузкиПоУмолчанию", Тип("ПолеФормы"), Группа);
	ПолеВвода.Заголовок = "Склад отгрузки по умолчанию";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.СкладОтгрузкиПоУмолчанию"; 
	
	ГруппаПотенциал = Элементы.Добавить("УпрГруппа1", Тип("ГруппаФормы"), Группа);
	ГруппаПотенциал.Вид = ВидГруппыФормы.ОбычнаяГруппа; 
	ГруппаПотенциал.Отображение = ОтображениеОбычнойГруппы.Нет;    
	ГруппаПотенциал.ОтображатьЗаголовок = ЛОЖЬ; 
	ГруппаПотенциал.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	
	ПолеВвода = Элементы.Добавить("ПотенциалКлиента", Тип("ПолеФормы"), ГруппаПотенциал);
	ПолеВвода.Заголовок = "Потенциальный объем";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода; 
	ПолеВвода.ПутьКДанным = "Объект.ПотенциалКлиента";  
	
	ПолеВвода = Элементы.Добавить("ТекстРуб", Тип("ДекорацияФормы"), ГруппаПотенциал);
	ПолеВвода.Заголовок = "руб";
	ПолеВвода.Вид = ВидДекорацииФормы.Надпись; 
	
	ПолеВвода = Элементы.Добавить("ТипКлиента", Тип("ПолеФормы"), Группа);
	ПолеВвода.Заголовок = "Тип клиента";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ТипКлиента";
	
	ПолеВвода = Элементы.Добавить("ЭтоОрганизация", Тип("ПолеФормы"), Группа);
	//ПолеВвода.Заголовок = "Это организация";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПодсказкаВвода = "Только для ВГО (ВНХ)";
	ПолеВвода.ПутьКДанным = "Объект.ЭтоОрганизация";
	
	ПолеВвода = Элементы.Добавить("СвежиеСрокиГодности", Тип("ПолеФормы"), Группа);
	ПолеВвода.Заголовок = "Свежие сроки годности";
	ПолеВвода.Вид = ВидПоляФормы.ПолеФлажка;
	ПолеВвода.ПутьКДанным = "Объект.СвежиеСрокиГодности";

	
КонецПроцедуры
